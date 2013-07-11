class Eventplanner.Models.Event extends Backbone.UndoModel
	toJSON: ->
    return { event: _.clone( this.attributes ) }

  @gridColumns: [
    {}= 
      name:     'name'
      label:    'Name'
      cell:     'string'
      placeholder: 'Event Name'
      width: 35
    {}= 
      name:     'location'
      label:    'Location'
      cell:     'string'
      placeholder: 'Event Location'
      width: 38
    {}= 
      name:     'date'
      label:    'Date'
      cell:     'datePicker'
      width: 20
    {}= 
      name:     'id'
      label:    'Edit'
      cell:     'edit'
      editable: false
      width: 5
    {}= 
      name:     'x'
      label:    'X'
      cell:     'delete'
      editable: false
      formatter: Backgrid.DeleteFormatter
      width: 2
  ]