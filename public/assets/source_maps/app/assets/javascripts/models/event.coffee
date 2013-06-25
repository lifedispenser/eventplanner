class Eventplanner.Models.Event extends Backbone.UndoModel
	toJSON: ->
    return { event: _.clone( this.attributes ) }

  @gridColumns: [
    {}= 
      name:     'name'
      label:    'Name'
      cell:     'string'
      width: 36
    {}= 
      name:     'location'
      label:    'Location'
      cell:     'string'
      width: 36
    {}= 
      name:     'date'
      label:    'Date'
      cell:     'datePicker'
      width: 23
    {}= 
      name:     'id'
      label:    'ID'
      cell:     'uri'
      editable: false
      formatter: Backgrid.EditLinkFormatter
      width: 3
    {}= 
      name:     'x'
      label:    'X'
      cell:     'delete'
      editable: false
      formatter: Backgrid.DeleteFormatter
      width: 2

  ]
