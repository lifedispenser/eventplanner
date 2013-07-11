class Backgrid.DatePickerEditor extends Backgrid.CellEditor
  formatter: new Backgrid.Extension.MomentFormatter()
  tagName: "input"
  attributes: 
    type: "text"
    class: "EP_Datepicker"

  events: 
    "change": "saveOrCancel"
    "keydown": "move"
    "datepickerclose": "move"

  render: ->
    @$el.val(@formatter.fromRaw(@model.get(@column.get("name"))))
    @$el.datepicker({
      dateFormat: "MM d, yy"
      autosize: true
      })
    return this
  
  saveOrCancel: (e) ->
    command = new Backgrid.Command(e)

    val = @$el.val()
    newValue = @formatter.toRaw(val)
    @$el.datepicker("destroy")

    if _.isUndefined(newValue)
      @model.trigger("backgrid:error", @model, @column, val)
    else
      @model.set(@column.get("name"), newValue)
      @model.trigger("backgrid:edited", @model, @column, command)
      Eventplanner.Grids["Items" + this.model.get("id")].body.saveAndRefresh()
      Eventplanner.Grids["Items" + @model.get("id")].collection.trigger("refresh:classes")
    return false
    

  move: (e) ->
    command = new Backgrid.Command(e)
    if command.moveUp() or command.moveDown() or command.moveLeft() or command.moveRight() or command.save() or command.cancel() or e.type == "datepickerclose"
     
      @$el.datepicker("destroy")
      $("#ui-datepicker-div").unbind().remove()
      e.preventDefault()
      e.stopPropagation()
      @model.trigger("backgrid:edited", @model, @column, command)
    return false



class Backgrid.DatePickerCell extends Backgrid.Extension.MomentCell
  editor: Backgrid.DatePickerEditor
  modelFormat: "YYYY-MM-DD"
  displayFormat: "MMMM D, YYYY"