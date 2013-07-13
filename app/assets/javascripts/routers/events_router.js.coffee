class Eventplanner.Routers.Events extends Backbone.Router
  initialize: (options) ->
    @events = new Eventplanner.Collections.Events()
    @templates = new Eventplanner.Collections.Templates()
    @events.reset options.events
    @templates.reset options.templates

  routes:
    "new"      : "newEvent"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "edit"
    ".*"        : "index"


  index: ->
    # header (static banner)
    head = new Eventplanner.Views.EventsIndexHead()
    $("#section-head").html(head.render())

    # body - several grids with colresizer
    body = new Eventplanner.Views.EventsIndex(collection: @events)
    grid = body.render()
    body_el = grid.$el
    $("#section-messages").html("");
    $("#section-body").html("
      <h3>Events that you are coordinating:</h3>
      ")
    $("#section-body").append(body_el)
    @addResizeableToGrid(body_el, @events.model.gridColumns)
    if Eventplanner.user is null
      $("#section-messages").html("
        <div id='flash_notice'>Register to track which events you are working on. </div>
        ")
      return

    grid.body.insertAddRow("+ Add New Event")
    
    template = new Eventplanner.Views.TemplatesIndex(collection: @templates)
    template_el = template.render()

    $("#section-body").append("
      <h3>Use or Modify a Template Below:</h3>
      ")
    $("#section-body").append(template_el)
    @addResizeableToGrid(template_el, @templates.model.gridColumns)
    $("#section-tools").html("");
    
  edit: (id) ->
    event = @events.get(id)
    collection = new Eventplanner.Collections.Items()
    #render a new event that is not in your events list
    if @events.get(id) is undefined and @templates.get(id) is undefined
      event = new Eventplanner.Models.Event {id: id}
      head = new Eventplanner.Views.EventEdit(model: event)
      event.item_collection = collection
      events = @events
      $("body").append("<div id='loading'> <h3>Loading...</h3> </div>")
      $("#loading").dialog({
        modal: true
      })
      event.fetch({
        success: (e) ->
          $("#loading").dialog("close")
          e.item_collection.reset e.get("items")
          e.item_collection.event = e
          e.item_collection.order()
          e.item_collection.trigger("refresh:classes")
          window.router.events.add(e)
          e.trigger("reset")
          $("#flash_notice").append("Have any questions? Contact the owner of the event <a target='_blank' href='mailto:" + e.get('owner').email + "?subject=" + e.get("name") + " planning question'>here</a>.")
        silent: true
        })
      if Eventplanner.user is null
        $("#section-messages").html("
          <div id='flash_notice'> Notice: Register to track which events you are working on and plan your own events. </div>
          ")
      else
        $("#section-messages").html("
          <div id='flash_notice'> Mark your items as pending or completed and write in your results. </div>
          ")
    #render a template
    else if event is undefined
      event ||= @templates.get(id)
      head = new Eventplanner.Views.TemplateEdit(model: event)
      $("#section-messages").html("
        <div id='flash_notice'> Notice: You are currently editing the template. If you would like to make an event from this template, go back home and click on 'use template'. </div>
        ")
      $(".export").text("Duplicate Template")
    #render normally
    else
      head = new Eventplanner.Views.EventEdit(model: event)
      if Eventplanner.user.id != event.get('owner').id
        $("#section-message").html("Have any questions? Contact the owner of the event <a target='_blank' href='mailto:" + event.get('owner').email + "?subject=" + event.get("name") + " planning question'>here</a>.")

      
    #render tools
    event_tools = new Eventplanner.Views.EventTools()
    $("#section-tools").html(event_tools.render().$el)
    event_tools.setupFunctionality(id)

    
    head_el = head.render()
    $("#section-head").html(head_el)
    @addResizeableToGrid(head_el, head.gridColumns)

    #render body grid
    collection.reset event.get("items")
    collection.event = event
    collection.order()
    body = new Eventplanner.Views.EventItems(collection: collection)
    grid = body.render()
    el = grid.$el
    $("#section-body").html(el)
    @addResizeableToGrid(el, collection.model.gridColumns)
    grid.pic.render()
    
  newEvent: ->
    return

  addResizeableToGrid: (el, gridColumns) ->
    splits = _.compact(_.pluck(gridColumns, "width")).join(";")
    el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: splits
      headerOnly: true
      postbackSafe: true
    })
    return el
