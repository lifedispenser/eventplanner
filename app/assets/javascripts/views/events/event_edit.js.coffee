class Eventplanner.Views.EventEdit extends Backbone.View
  initialize: (options) ->
    @model = options.model
    @collection = new Eventplanner.Collections.Events()
    @collection.reset [@model]

  render: ->
    #remove otherwise this grid will catch all the event triggers for some reason
    Eventplanner.Grids['Events'].remove() if Eventplanner.Grids['Events']
    Eventplanner.Grids['Event' + @model.get('id')] ?= new Backgrid.Grid({
      headerCell: Backgrid.Cell
      collection: @collection
      columns: @gridColumns
    })
    grid = Eventplanner.Grids['Event' + @model.get('id')]
    grid.render()
    grid.$el.attr("id", 'Event' + @model.get('id'))
    return grid.$el

  gridColumns: [
    {}= 
      name:     'name'
      label:    'Name'
      cell:     'string'
      placeholder: 'Event Name'
      width: 50
      sortable: false
    {}= 
      name:     'location'
      label:    'Location'
      cell:     'string'
      placeholder: 'Event Location'
      width: 25
      sortable: false
    {}= 
      name:     'date'
      label:    'Due Date'
      cell:     'datePicker'
      width: 25
      sortable: false
  ]