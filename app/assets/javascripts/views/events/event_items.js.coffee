class Eventplanner.Views.EventItems extends Backbone.View

  initialize: () ->
    @collection = @options.collection

  render: ->
    #re-render it every time it gets called
    Eventplanner.Grids['Items' + @collection.event.get('id')] = new Backgrid.Grid({
      headerCell: Backgrid.Cell
      collection: @collection
      columns: @collection.model.gridColumns
      body: Backgrid.sortableBody
      row: Backgrid.sortableRow
    })
    grid = Eventplanner.Grids['Items' + @collection.event.get('id')]
    grid.render()
    grid.$el.attr("id", 'Items' + @collection.event.get('id'))
    grid.insertAddRow("+ Add New Item") if @collection.length is 0
    grid.body.$el.sortable({
      handle: ".dragger"
      containment: "parent"
      forceHelperSize: true
      forcePlaceholderSize: true
      helper: "clone"
      placeholder: ".sort_placeholder"
      revert: 10
      update: (e, ui) ->
        ui.item.trigger("updated_index", ui.item.index())
      })
    return grid.$el