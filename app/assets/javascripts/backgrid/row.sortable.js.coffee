class Backgrid.sortableRow extends Backgrid.hasClassRow
  events: 
    'updated_index': 'updateIndex'

  updateIndex: (event, index) -> 
    @model.collection.move(@model, index)
    if index == 0 
      @model.set({
        child: null
        })
      @model.save()
    
    @$el.trigger("saveAndRefresh")
