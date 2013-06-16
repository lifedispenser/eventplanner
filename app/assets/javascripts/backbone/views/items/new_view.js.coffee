Eventplanner.Views.Items ||= {}

class Eventplanner.Views.Items.NewView extends Backbone.View
  template: JST["backbone/templates/items/new"]

  events:
    "submit #new-items": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (items) =>
        @model = items
        window.location.hash = "/#{@model.id}"

      error: (items, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
