class Eventplanner.Views.EventEdit extends Backbone.View
  template: JST['events/edit']

  render: ->
    return @template(@model.toJSON())
