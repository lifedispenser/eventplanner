class Eventplanner.Views.TemplatesIndex extends Backbone.View

  initialize: () ->
    @collection = @options.collection
    
  render: ->
    Eventplanner.Grids["Templates"] = new Backgrid.Grid({
      collection: @collection
      columns: @collection.model.gridColumns
    })
    grid = Eventplanner.Grids["Templates"]
    grid.render()
    
    return grid.$el

