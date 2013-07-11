class EventsController < ApplicationController
  layout "events"
  # GET /events
  # GET /events.json
  def index
    if current_user 
      @events = current_user.events(:include => :items) 
      @contacts = current_user.contacts_autocomplete
      @templates = Event.where(:template => [current_user.id, 0]).includes(:items)
    else 
      session['events'] ||= []
      ids = session['events']
      @events = Event.find_all_by_id(ids, :include => :items)
      @contacts = ""
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events.to_json(:include => :items) }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @event = Event.find(params[:id], :include => :items)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event.to_json(:include => :items) }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
    create
    @event = Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id], :include => :items)
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(params[:event])
    @event.owner = current_user if current_user
    respond_to do |format|
      if @event.save
        if !current_user
          session['events'] ||= []
          session['events'] << @event.id
        end
        format.html { redirect_to ('/events#' + @event.id.to_s) }
        format.json { render json: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.json
  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update_attributes(params[:event].slice(*Event.accessible_attributes.to_a))
        format.html { redirect_to @event, notice: 'event was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def eventcode 
    args = Base64.urlsafe_decode64(params[:code]).split("|zq|")
    if args[0] != ""
      event = Event.find(args[0])
    end
    if args[1] != ""
      user = User.where(
        user_id: @user.id, 
        role_id: 2, 
        creator_id: current_user.id).first_or_create
    end
  end

  def save_template
    @event = Event.find(params[:id])
    @event.template_title = params[:template_title]
    @event.template_desc = params[:template_desc]

    @template = @event.dup
    @template.template = current_user ? current_user.id : 0
    @template.name = ""
    @template.location = ""
    @template.date = nil
    @template.save

    ids = @event.items.map { |item| item.id }
    new_order = []
    @event.order.split(',').each do |id|
      new_item = @event.items.at(ids.index(id.to_i)).dup
      new_item.event_id = @template.id
      new_item.result = ""
      new_item.status = ""
      new_item.person_in_charge = ""
      new_item.save
      new_order.push(new_item.id)
    end
    @template.order = new_order.join(",")

    if @template.save
      respond_to do |format|
        format.json { render :json => @template, :include => :items }
      end
    end
  end

  def load_template
    @template = Event.find(params[:id]) 
    @event = @template.dup
    @event.template = nil
    @event.template_title = ""
    @event.template_desc = ""
    @event.owner = current_user if current_user
    @event.save

    ids = @template.items.map { |item| item.id }
    new_order = []
    @template.order.split(',').each do |id|
      new_item = @template.items.at(ids.index(id.to_i)).dup
      new_item.event_id = @event.id
      new_item.save
      new_order.push(new_item.id)
    end
    @event.order = new_order.join(",")

    if @event.save
      respond_to do |format|
        format.json { render :json => @event, :include => :items }
      end
    end
  end

end
