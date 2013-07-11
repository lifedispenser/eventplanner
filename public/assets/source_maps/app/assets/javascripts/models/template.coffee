class Eventplanner.Models.Template extends Backbone.UndoModel
  toJSON: ->
    return { event: _.clone( this.attributes ) }

  @gridColumns: [
    {}= 
      name:     'template_title'
      label:    'Title'
      cell:     'string'
      placeholder: 'Template Title'
      width: 23
    {}= 
      name:     'template_desc'
      label:    'Description'
      cell:     'string'
      placeholder: 'Template Description'
      width: 60
    {}= 
      name:     'id'
      label:    'Use Template'
      cell:     'use'
      editable: false
      width: 10
    {}= 
      name:     'id'
      label:    'Edit'
      cell:     'edit'
      editable: false
      formatter: Backgrid.EditLinkFormatter
      width: 5
    {}= 
      name:     'x'
      label:    'X'
      cell:     'delete'
      editable: false
      formatter: Backgrid.DeleteFormatter
      width: 2
  ]
