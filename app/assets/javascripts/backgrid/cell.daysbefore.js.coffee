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
    return "" if raw is null or raw is ""
    return raw + " days before event" unless moment(this.model.collection.event.get("date"))
    return moment(@model.collection.event.get("date")).subtract('days', parseInt(raw)).format("MMMM D, YYYY")

  toRaw: (data) ->
    return parseInt(data) unless isNaN(parseInt(data))
    return ''