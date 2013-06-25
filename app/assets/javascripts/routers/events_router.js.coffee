class Eventplanner.Routers.Events extends Backbone.Router
  initialize: (options) ->
    @events = new Eventplanner.Collections.Events()
    @events.reset options.events

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
    $("#section-body").html(body.render())
    
  edit: (id) ->
    event = @events.get(id)
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