class Eventplanner.Views.Events.Index.EventsGrid extends Backbone.View

  initialize: () ->
    @collection = @options.collection
    
  render: ->
    Eventplanner.Grids["Events"] = new Backgrid.Grid({
      collection: @collection
      columns: @collection.model.gridColumns
    })
    # avoid same collection Grid conflicts
    _.each(Eventplanner.Grids, (grid,id) ->
      if id.match(/Event[0-9]+/)
        grid.remove()
      )
    grid = Eventplanner.Grids["Events"]
    grid.render()
    return grid

