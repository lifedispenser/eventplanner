class Backgrid.sortableBody extends Backgrid.Body
  initialize: (options) ->
    super (options)
    @listenTo(@collection, "backgrid:edited", @setClasses)
    @listenTo(@collection, "refresh:classes", @_refresh)
    @listenTo(@collection, "saveAndRefresh", @saveAndRefresh)
    #global pollution!!!
    @listenTo(Backbone, "Eventplanner:refreshrowclasses", @_refresh)
    @setClasses()

  
  saveAndRefresh: () ->
    @_refresh()

  # so no order is called when you just need to refresh the grid
  _refresh: () ->
    @refresh()
    @setClasses()
    @insertAddRow("+ Add Row")


  setClasses: () ->
    return if @collection.length is 0
    @collection.at(@collection.length-1).trigger("hasclass:refresh")