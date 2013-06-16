class Backgrid.sortableRow extends Backgrid.hasClassRow
  events: 
    'updated_index': 'updateIndex'

  updateIndex: (event, index) -> 
    @model.collection.move(@model, index)
    this.$el.trigger("saveAndRefresh")
