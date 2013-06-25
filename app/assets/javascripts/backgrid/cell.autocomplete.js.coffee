AutoCompleteFormatter = {
  fromRaw: (data) ->
    return "#{data['name']} <span class='email'>#{data['email']}</span>" if data
    return ""

  toRaw: (ele) ->
    if $(ele).data("complexvalue")
      if $(ele).data("complexvalue")['email']
        return JSON.stringify($(ele).data("complexvalue")) 
    return undefined

  toData: (str) ->
    if !(_.isUndefined(str) or str is "" or str is null)
      return $.parseJSON(str)
    return false
}

class Backgrid.AutoCompleteEditor extends Backgrid.CellEditor
  formatter: AutoCompleteFormatter
  tagName: "input"
  attributes: 
    type: "text"

  events: 
    "close" : "saveOrCancel"
    "autocompleteselected": "saveOrCancel"
    "blur" : "saveOrCancel"
    "change" : "saveOrCancel"
    'keydown': "escape"

  render: ->
    data = @formatter.toData(@model.get(@column.get("name")))
    if(data)
      @$el.data("complexvalue", data)
      if data['name'] == ""
        @$el.val(data['email'])
      else
        @$el.val(data['name'])


    @$el.autocomplete({
      minLength: 2
      source: (request, response) ->
        results = $.ui.autocomplete.filter(Eventplanner.contacts, request.term)
        response(results.slice(0, 10))

      focus: (event, ui) -> 
        $(event.target).val(ui.item.label)
        return false

      select: (event, ui) ->
        $(event.target).val(ui.item.label)
          .data("complexvalue", {
            name: ui.item.label
            email: ui.item.email
          })
        $(event.target).trigger("autocompleteselected")
        return false

      })
    @$el.data( "ui-autocomplete" )._resizeMenu = () ->
      ul = @menu.element
      ul.outerWidth(@element.outerWidth())
    @$el.data( "ui-autocomplete" )._renderItem = ( ul, item ) ->
      return $( "<li>" )
      .append( "<a>" + item.label + "<br><span class='email'>" + item.email + "</span></a>" )
      .appendTo( ul )
    @$el.select()
    return this
  
  saveOrCancel: (e) ->
    command = new Backgrid.Command(e)
    newValue = @formatter.toRaw(@$el)
    @$el.autocomplete("destroy")
    if e.target.value.length == 0
      @model.set(@column.get("name"), "")
    else if _.isUndefined(newValue) or (e.target.value != @$el.data("complexvalue")['name'])
        data = {
          name: ""
          email: e.target.value 
        }
        @model.set(@column.get("name"), JSON.stringify(data))
    else 
      @model.set(@column.get("name"), newValue)
    
    @model.trigger("backgrid:edited", @model, @column, command)
    e.stopPropagation()
    e.preventDefault()
    

  escape: (e) -> 
    command = new Backgrid.Command(e)
    if command.cancel() or command.moveLeft() or command.moveRight()
      @$el.autocomplete("destroy")
      e.stopPropagation()
      e.preventDefault()
      @model.trigger("backgrid:edited", @model, @column, command) 

class Backgrid.AutoCompleteCell extends Backgrid.Cell
  editor: Backgrid.AutoCompleteEditor
  formatter: AutoCompleteFormatter

  render:  () ->
    @$el.empty()
    if(@column.get("width"))
      @el.style.width = @column.get("width")
    data = @formatter.toData(@model.get(@column.get("name")))
    if data
      @$el.html(@formatter.fromRaw(data))
    else
      @$el.html("")
    @delegateEvents()
    return this
