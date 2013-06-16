class Eventplanner.Views.EventsIndex extends Backbone.View

  initialize: () ->
    @collection = @options.collection
    
  render: ->
    Eventplanner.Grids["Events"] ?= new Backgrid.Grid({
      collection: @collection
      columns: @collection.model.gridColumns
    })
    grid = Eventplanner.Grids["Events"]
    grid.render()
    grid.insertAddRow("+ New Event")
    
    return grid.$el

