class Backgrid.sortableBody extends Backgrid.Body
  initialize: (options) ->
    super (options)
    @listenTo(@collection, "backgrid:edited", @setClasses)
    @listenTo(@collection, "refresh:classes", @setClasses)
    @setClasses()

  events: 
    'saveAndRefresh': 'saveAndRefresh'

  saveAndRefresh: () ->
    @collection.event.set({
      order: _.compact(@collection.pluck("id")).toString()
    })
    @refresh()
    @setClasses()

  setClasses: () ->
    return if @collection.length is 0
    @collection.at(@collection.length-1).trigger("hasclass:refresh")