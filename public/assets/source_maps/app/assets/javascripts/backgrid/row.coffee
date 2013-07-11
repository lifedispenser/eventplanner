class Backgrid.hasClassRow extends Backgrid.Row
  events:
    "indent": "indent"
    "unindent": "unindent"

  initialize: (options) ->
    super (options)
    @listenTo(@model, "hasclass:refresh", @setClasses)

  indent: () ->
    console.log('hi')
    @model.set({
      child: 1
      }, {silent: true})

  unindent: () ->
    @model.set({
      child: null
      }, {silent: true})
    console.log('hi')

  #gets called on the last row 
  setClasses: ->
    @$el.removeClass()
    #is el a parent?
    index = @model.collection.indexOf(@model)

    #refresh the previous rows in case of change in the child
    if (index-1 >= 0)
      parent = @model.collection.at(index-1)
      parent.trigger("hasclass:refresh")

    #refresh all to make sure previous parents are undone
    if (index + 1 != @model.collection.length)
      #check if next row is a child element
      if _.isNumber(@model.collection.at(index+1).get("child")) and !_.isNumber(@model.get("child"))
        @$el.addClass("parent")
        #check if existing was parent and refresh
        return true
        #ignore other visualizations like complete, pending, etc

    #is el a child?
    if _.isNumber(@model.get("child"))
      @$el.addClass("child")

    #el has a status?
    if !(@model.get("status") == "" or @model.get("status") == null)
      @$el.addClass(@model.get('status'))
    else if _.isNumber(@model.get("days_before")) and moment(@model.collection.event.get('date'))
      if @daydiff(moment(), moment(@model.collection.event.get('date'))) < @model.get('days_before')
        @$el.addClass('overdue')

  daydiff: (first, second) ->
    return Math.round((second-first)/(1000*60*60*24))
