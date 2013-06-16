class Backgrid.sortableBody extends Backgrid.Body
  events: 
    'saveAndRefresh': 'saveAndRefresh'

  saveAndRefresh: () ->
    console.log("saveAndRefresh")
    @collection.event.set({
      order: @collection.pluck("id").toString()
    })
    @refresh()