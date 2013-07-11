class Backgrid.DeleteCell extends Backgrid.Cell
  formatter: Backgrid.DeleteFormatter

  events: {
    "click" : "removeEvent"
  }

  render: ->
    @$el.empty()
    if(@column.get("width"))
      @el.style.width = @column.get("width");
    @$el.addClass("EPdelete")
    @$el.attr("model_id", @model.get("id"))
    @$el.text(@formatter.fromRaw(@model.get(@column.get("name"))));
    @delegateEvents();
    return this

  removeEvent: (e) ->
    if (window.confirm("Are you sure you want to delete this event?"))
      @model.destroy()
    
  
#Todo - make a better URICell!
Backgrid.DeleteFormatter = {
  fromRaw: (raw) ->
    return "X"
  toRaw: (data) ->
    return ""
  }