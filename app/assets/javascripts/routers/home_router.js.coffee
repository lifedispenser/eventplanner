class Eventplanner.Routers.Home extends Backbone.Router
  initialize: (options) ->
    @templates = new Eventplanner.Collections.Templates()
    @templates.reset options.introTemplates
    @assign = new Eventplanner.Collections.Events()
    @assign.reset options.assignItemEvents
    @fillin = new Eventplanner.Collections.Events()
    @fillin.reset options.fillInEvents
    @check = new Eventplanner.Collections.Events()
    @check.reset options.checkEvents
    
  routes:
    ""    : "index"
    
  index: ->
    # body - several grids with colresizer
    one = new Eventplanner.Views.TemplatesIndex(collection: @templates)
    one_el = one.render()
    $("#create-event").html(one_el)
    @addResizeableToGrid(one_el, @templates.model.gridColumns)

    
    col_1 = new Eventplanner.Collections.Items()
    col_1.reset @assign.at(0).get('items')
    col_1.event = @assign.at(0)
    two = new Eventplanner.Views.EventItems(collection: col_1)
    grid_two = two.render()
    two_el = grid_two.$el
    $("#assign-items").html(two_el)
    @addResizeableToGrid(two_el, col_1.model.gridColumns)

    col_2 = new Eventplanner.Collections.Items()
    col_2.reset @fillin.at(0).get('items')
    col_2.event = @fillin.at(0)
    three = new Eventplanner.Views.EventItems(collection: col_2)
    grid_three = three.render()
    three_el = grid_three.$el
    $("#fill-in-results").html(three_el)
    @addResizeableToGrid(three_el, col_2.model.gridColumns)

    col_3 = new Eventplanner.Collections.Items()
    col_3.reset @check.at(0).get('items')
    col_3.event = @check.at(0)
    four = new Eventplanner.Views.EventItems(collection: col_3)
    grid_four = four.render()
    four_el = grid_four.$el
    $("#check-items").html(four_el)
    @addResizeableToGrid(four_el, col_3.model.gridColumns)
    return


  addResizeableToGrid: (el, gridColumns) ->
    splits = _.compact(_.pluck(gridColumns, "width")).join(";")
    el.colResizable({
      draggingClass:"dragging"
      liveDrag: true
      defaultSplits: splits
      headerOnly: true
      postbackSafe: true
    })
    return el

