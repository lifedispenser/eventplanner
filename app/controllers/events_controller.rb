class EventsController < ApplicationController
  layout "events"
  # GET /events
  # GET /events.json
  def index
    if current_user 
      @user = current_user
      @events = current_user.events(:select => 'events.*, items.*, users.name, users.email, users.id', :include => [:items, :owner]) 
      @contacts = current_user.contacts_autocomplete
      @templates = Event.where(:template => current_user.id).includes(:items)
    else 
      session['events'] ||= []
      ids = session['events']
      @events = Event.find_all_by_id(ids, :include => :items)
      @contacts = ""
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @events.as_json(:include => :items).to_json }
    end
  end

  # GET /events/1 t
  # GET /events/1.json
  def show
    id = Event.id_from_code params[:id]
    @event = Event.find(id, :include => :items)
    EventUser.find_or_create_by_user_id_and_event_id(current_user.id, @event.id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @event.as_json(:include => {items: {},owner: {only: ['name','email','id']}}).to_json }
    end
  end

  # GET /events/new
  # GET /events/new.json
  def new
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
        format.json { render json: @event.as_json(:include => { owner: { only: ['name', 'id', 'email']}}).to_json, status: :created, location: @event }
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
    if current_user.id == @event.template
      @event.destroy
    elsif current_user.id == @event.owner.id
      @event.destroy
    else
      @eu = EventUser.where(event_id: @event.id, user_id: current_user.id).first.destroy
    end
    respond_to do |format|
      format.html { redirect_to events_url }
      format.json { head :no_content }
    end
  end

  def save_template
    @event = Event.find(params[:id])
    @template = @event.dup_as_template(current_user, params[:template_title], params[:template_desc])

    respond_to do |format|
      format.json { render :json => @template, :include => :items }
    end
  end

  def load_template
    @template = Event.find(params[:id]) 
    @event = @template.dup_as_event (current_user)
    respond_to do |format|
      format.json { render :json => @event, :include => {items: {}, owner: {only: ['name', 'email', 'id']} }}
    end
    
  end

end
