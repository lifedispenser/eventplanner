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
    $("#section-head").html(head.render())
    
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
