class Eventplanner.Views.EventsRow extends Backbone.View
  template: JST['events/row']

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
