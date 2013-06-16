class Backgrid.DaysBeforeEditor extends Backgrid.InputCellEditor
  tagName: "input"
  attributes: 
    type: "text"
    placeholder: "# days before event"

  render: ->
    val = @model.get(@column.get("name"))
    @$el.val(val)
    return this
  


class Backgrid.DaysBeforeCell extends Backgrid.IntegerCell
  editor: Backgrid.DaysBeforeEditor

  initialize: (options) ->
    super options
    @formatter = this

  fromRaw: (raw) ->
    return "" if !raw
    return moment(@model.collection.event.get("date")).subtract('days', raw).format("MMMM D, YYYY")

  toRaw: (data) ->
    return data