class Eventplanner.Views.TemplateEdit extends Backbone.View
  initialize: (options) ->
    @model = options.model
    @collection = new Eventplanner.Collections.Templates()
    @collection.reset [@model]

  render: ->
    #remove otherwise this grid will catch all the event triggers for some reason
    Eventplanner.Grids['Events'].remove() if Eventplanner.Grids['Events']
    Eventplanner.Grids['Templates'].remove() if Eventplanner.Grids['Templates']
    Eventplanner.Grids['Template' + @model.get('id')] ?= new Backgrid.Grid({
      headerCell: Backgrid.Cell
      collection: @collection
      columns: @gridColumns
    })
    grid = Eventplanner.Grids['Template' + @model.get('id')]
    grid.render()
    grid.$el.addClass("template")
    grid.$el.attr("id", 'Template' + @model.get('id'))
    return grid.$el

  gridColumns: [
    {}= 
      name:     'template_title'
      label:    'Title'
      cell:     'string'
      placeholder: 'Title'
      width: 30
      sortable: false
    {}= 
      name:     'template_desc'
      label:    'Description'
      cell:     'string'
      placeholder: 'A short description of this event.'
      width: 70
      sortable: false
  ]
