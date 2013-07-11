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
      <h3>View Events that you are planning:</h3>
      ")
    $("#section-body").append(body_el)
    body_el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: body_splits
      headerOnly: true
      postbackSafe: true
    })
    
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
    
    #render tools
    event_tools = new Eventplanner.Views.EventTools()
    $("#section-tools").html(event_tools.render().$el)
    event_tools.setupFunctionality(id)

    #render head
    if event is undefined
      event ||= @templates.get(id)
      head = new Eventplanner.Views.TemplateEdit(model: event)
      $("#section-messages").html("
        <div id='flash_notice'> Notice: You are currently editing the template. If you would like to make an event from this template, go back home and click on 'use template'. </div>
        ")
      $(".export").text("Duplicate Template")
    else
      head = new Eventplanner.Views.EventEdit(model: event)
    
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
    collection = new Eventplanner.Collections.Items()
    collection.reset event.get("items")
    collection.event = event
    collection.order()
    body = new Eventplanner.Views.EventItems(collection: collection)
    splits = _.compact(_.pluck(collection.model.gridColumns, "width")).join(";")
    el = body.render()
    $("#section-body").html(el)
    el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: splits
      headerOnly: true
      postbackSafe: true
    })
    

    
  newEvent: ->
    return
