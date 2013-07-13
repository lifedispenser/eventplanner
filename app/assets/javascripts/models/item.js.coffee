class Eventplanner.Models.Item extends Backbone.UndoModel
  toJSON: ->
    return { item: _.clone( this.attributes ) }
  
  @gridColumns: [
    {}= 
      name:     'description'
      label:    'Description'
      cell:     'sortable'
      width: 25
      sortable: false
    {}= 
      name:     'result'
      label:    'Result/Summary'
      cell:     'string'
      width: 35
      sortable: false
    {}= 
      name:     'person_in_charge'
      label:    'Person in Charge'
      cell:     'autoComplete'
      width: 18
      sortable: false
    {}= 
      name:     'days_before'
      label:    'Complete By'
      cell:     'daysBefore'
      width: 12
      sortable: false
    {}= 
      name:     'status'
      label:    'Status'
      cell:     Backgrid.SelectCell.extend({
        optionValues: [ 
          ["", ""]
          ["Pending", "pending"]
          ["Completed", "completed"]
        ]
      })
      width: 7
      sortable: false
    {}= 
      name:     'id'
      label:    'ID'
      cell:     'integer'
      editable: false
      renderable: false
      sortable: false
    {}= 
      name:     'event_id'
      label:    ''
      cell:     'integer'
      editable: false
      renderable: false
      sortable: false
    {}= 
      name:     'setting'
      label:    ''
      cell:     'settings'
      width: 3
      editable: false
      sortable: false
  ]