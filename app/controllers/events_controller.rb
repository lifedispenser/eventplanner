class EventsController < ApplicationController
  layout "events"
  # GET /events
  # GET /events.json
  def index
    @events = current_user.events(:include => :items)
    @contacts = current_user.contacts_autocomplete

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
    @event.owner = current_user
    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: 'event was successfully created.' }
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
end
