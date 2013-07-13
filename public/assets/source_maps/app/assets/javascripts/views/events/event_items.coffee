class Eventplanner.Views.EventItems extends Backbone.View

  initialize: () ->
    @collection = @options.collection

  render: ->
    #re-render it every time it gets called
    Eventplanner.Grids['Items' + @collection.event.get('id')] ?= new Backgrid.Grid({
      headerCell: Backgrid.Cell
      collection: @collection
      columns: @collection.model.gridColumns
      body: Backgrid.sortableBody
      row: Backgrid.sortableRow
    })
    grid = Eventplanner.Grids['Items' + @collection.event.get('id')]
    grid.render()
    grid.$el.attr("id", 'Items' + @collection.event.get('id'))
    grid.body.$el.sortable({
      handle: ".dragger"
      forceHelperSize: true
      forcePlaceholderSize: true
      axis: 'y'
      helper: (event, ele) ->
        target = $(ele)
        target_children = $(ele).children()
        clone = target.clone()
        clone.children().width((i,val) ->
          return target_children.eq(i).width()
        )
        return clone
      placeholder: ".sort_placeholder"
      revert: 40
      update: (e, ui) ->
        ui.item.trigger("updated_index", ui.item.index())
      })
    #fix bug where cell is still in input mode after a history back/forward
    grid.body._refresh()
    grid.pic = new Eventplanner.Views.PersonInCharge(grid: grid)
    return grid
