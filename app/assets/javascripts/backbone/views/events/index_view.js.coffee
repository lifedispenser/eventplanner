Eventplanner.Views.Events ||= {}

class Eventplanner.Views.Events.IndexView extends Backbone.View
  template: JST["templates/events/event_index"]

  initialize: () ->
    @options.events.bind('reset', @addAll)

  addAll: () =>
    @options.events.each(@addOne)

  addOne: (event) =>
    view = new Eventplanner.Views.Events.EventView({model : event})
    @$("tbody").append(view.render().el)

  render: =>
    $(@el).html(@template(events: @options.events.toJSON() ))
    @addAll()

    return this