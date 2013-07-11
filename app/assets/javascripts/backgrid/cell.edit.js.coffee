class Backgrid.EditCell extends Backgrid.Cell
  formatter: Backgrid.EditFormatter

  render: ->
    @$el.empty()
    @$el.addClass("edit-cell")
    @$el.html("<a href='/events##{@model.get(@column.get("name")).toString()}'> Edit </a>")
    return this
  