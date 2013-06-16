class Eventplanner.Routers.EventsRouter extends Backbone.Router
  initialize: (options) ->
    @events = new Eventplanner.Collections.EventsCollection()
    @events.reset options.events

  routes:
    "new"      : "newEvent"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newEvent: ->
    @view = new Eventplanner.Views.Events.NewView(collection: @events)
    $("#section-body").html(@view.render().el)

  index: ->
    @view = new Eventplanner.Views.Events.IndexView(events: @events)
    $("#section-body").html(@view.render().el)

  edit: (id) ->
    event = @events.get(id)
    event.items = event.get('items')

    @headview = new Eventplanner.Views.Events.EditView(model: event)
    $("#section-head").html(@headview.render().el)

    @bodyview = new Eventplanner.Views.Events.Items.EditView(collection: event.items)
    $("#section-body").html(@bodyview.render().el)