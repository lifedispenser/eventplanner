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
    head = new Eventplanner.Views.EventsIndexHead()
    $("#section-head").html(head.render())
    body = new Eventplanner.Views.EventsIndex(collection: @events)
    body_splits = _.compact(_.pluck(@events.model.gridColumns, "width")).join(";")
    body_el = body.render()
    $("#section-messages").html("");
    $("#section-body").html("
      <h3>Events that you are coordinating:</h3>
      ")
    $("#section-body").append(body_el)
    body_el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: body_splits
      headerOnly: true
      postbackSafe: true
    })
    if Eventplanner.user is null
      $("#section-messages").html("
        <div id='flash_notice'>Register to track which events you are working on. </div>
        ")
      return
    
    template = new Eventplanner.Views.TemplatesIndex(collection: @templates)
    template_splits = _.compact(_.pluck(@templates.model.gridColumns, "width")).join(";")
    template_el = template.render()

    $("#section-body").append("
      <h3>Use or Modify a Template Below:</h3>
      ")
    $("#section-body").append(template_el)
    template_el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: template_splits
      headerOnly: true
      postbackSafe: true
    })    
    $("#section-tools").html("");
    
  edit: (id) ->
    event = @events.get(id)
    collection = new Eventplanner.Collections.Items()
    #render a new event that is not in your events list
    if @events.get(id) is undefined and @templates.get(id) is undefined
      event = new Eventplanner.Models.Event {id: id}
      event.item_collection = collection
      events = @events
      event.fetch({
        success: (e) ->
          e.item_collection.reset e.get("items")
          e.item_collection.event = e
          e.item_collection.order()
          e.item_collection.trigger("refresh:classes")
          Eventplanner.Grids.Events.collection.add(e)
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
        $("#section-messages").html("
          <div id='flash_notice'>  Mark your items as pending or completed and write in your results. Have any questions? Contact the owner of the event <a target='_blank' href='mailto:" + event.get('owner').email + "?subject=" + event.get("name") + " planning question'>here</a>. 
          </div>")

      
    #render tools
    event_tools = new Eventplanner.Views.EventTools()
    $("#section-tools").html(event_tools.render().$el)
    event_tools.setupFunctionality(id)

    
    head_splits = _.compact(_.pluck(head.gridColumns, "width")).join(";")
    head_el = head.render()
    $("#section-head").html(head_el)
    head_el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: head_splits
      headerOnly: true
      postbackSafe: true
    })
    #render body grid
    collection.reset event.get("items")
    collection.event = event
    collection.order()
    body = new Eventplanner.Views.EventItems(collection: collection)
    splits = _.compact(_.pluck(collection.model.gridColumns, "width")).join(";")
    grid = body.render()
    el = grid.$el
    $("#section-body").html(el)
    el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: splits
      headerOnly: true
      postbackSafe: true
    })
    grid.pic.render()

    
  newEvent: ->
    return
