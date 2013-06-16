class Eventplanner.Routers.ItemsRouter extends Backbone.Router
  initialize: (options) ->
    @items = new Eventplanner.Collections.ItemsCollection()
    @items.reset options.items

  routes:
    "new"      : "newItems"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newItems: ->
    @view = new Eventplanner.Views.Items.NewView(collection: @items)
    $("#items").html(@view.render().el)

  index: ->
    @view = new Eventplanner.Views.Items.IndexView(items: @items)
    $("#items").html(@view.render().el)

  show: (id) ->
    items = @items.get(id)

    @view = new Eventplanner.Views.Items.ShowView(model: items)
    $("#items").html(@view.render().el)

  edit: (id) ->
    items = @items.get(id)

    @view = new Eventplanner.Views.Items.EditView(model: items)
    $("#items").html(@view.render().el)
