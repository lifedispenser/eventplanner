Eventplanner.Views.Items ||= {}

class Eventplanner.Views.Items.EditView extends Backbone.View
  template : JST["backbone/templates/items/edit"]

  events :
    "submit #edit-items" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (items) =>
        @model = items
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
