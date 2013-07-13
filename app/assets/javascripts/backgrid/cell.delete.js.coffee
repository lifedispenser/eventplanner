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
    if @model.get("template") == Eventplanner.user.id
      @$el.html(" &times;")    
    else if @model.get("owner")
      if @model.get("owner").id == Eventplanner.user.id
        @$el.html(" &times;")
      else
        @$el.html(" &minus;")    
    else 
      @$el.html(" &minus;") 
    @delegateEvents();
    return this

  removeEvent: (e) ->
    if @model.get("template") == Eventplanner.user.id
      if window.confirm("Are you sure you want to delete this template?")
        @model.destroy()
    else if @model.get("owner").id == Eventplanner.user.id
      if window.confirm("You are the owner of this event, so this will delete it. Are you sure you want to delete this event?")
        @model.destroy()
    else 
      if window.confirm("Because you are not the owner, you are only removing this event from your list. Are you sure you want to do this?")
        @model.destroy()

#Todo - make a better URICell!
Backgrid.DeleteFormatter = {
  fromRaw: (raw) ->
    return "X"
  toRaw: (data) ->
    return ""
  }