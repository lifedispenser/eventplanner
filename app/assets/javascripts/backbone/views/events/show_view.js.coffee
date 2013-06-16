Eventplanner.Views.Events ||= {}

class Eventplanner.Views.Events.ShowView extends Backbone.View
  template: JST["backbone/templates/events/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this