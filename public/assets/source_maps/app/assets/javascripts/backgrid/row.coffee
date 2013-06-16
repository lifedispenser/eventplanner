class Backgrid.hasClassRow extends Backgrid.Row
  initialize: (options) ->
    super (options)
    @listenTo(@model, "backgrid:edited", @setClasses)
    @listenTo(@model, "hasclass:refresh", @setClasses)
    @setClasses()

  setClasses: ->
    @$el.removeClass()
    #is el a parent?
    index = @model.collection.indexOf(@model)
    #refresh all to make sure previous parents are undone
    if (index-1 >= 0)
      parent = @model.collection.at(index-1)
      parent.trigger("hasclass:refresh")
    if (index + 1 != @model.collection.length)
      #check if next row is a child element
      if _.isNumber(@model.collection.at(index+1).get("parent_id")) and !_.isNumber(@model.get("parent_id"))
        @$el.addClass("parent")
        #check if existing was parent and refresh
        return true
        #ignore other visualizations like complete, pending, etc

    #is el a child?
    if _.isNumber(@model.get("parent_id"))
      @$el.addClass("child")

    #el has a status?
    if !(@model.get("status") == "" or @model.get("status") == null)
      @$el.addClass(@model.get('status'))
    else if @model.get("days_before") != null
      if @daydiff(moment(), moment(@model.collection.event.get('date'))) < @model.get('days_before')
        @$el.addClass('overdue')

  daydiff: (first, second) ->
    return Math.round((second-first)/(1000*60*60*24))
