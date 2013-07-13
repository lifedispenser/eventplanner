Backgrid.Body::insertAddRow = (text) ->
  newrow = new Backgrid.AddRow({
    emptyText: text
    columns: @columns
    body: this
  })
  @el.appendChild(newrow.render())
  return @el

class Backgrid.AddRow extends Backgrid.EmptyRow
  initialize: (options) ->
    Backgrid.requireOptions(options, ["emptyText", "columns", "body"])
    @body = @options.body
    @emptyText = @options.emptyText
    @columns =  @options.columns

  events: 
    "click": "addNewRow"

  render: ->
    @$el.empty()

    td = document.createElement("td");
    
    td.setAttribute("colspan", @columns.where({renderable:true}).length);
    td.textContent = @emptyText;

    @el.setAttribute("class", "newRow");
    @el.appendChild(td);

    return @el

  addNewRow: ->
    #super hack to deal with different grid types (template, items, events)!!!! will think about later
    if !_.isUndefined(@body.collection.event)
      model = @body.collection.create({
        event_id: @body.collection.event.get('id')
      }, {wait: true})
    else
      model = @body.collection.create({},{wait: true})
    @body.collection.once("sync", () ->
      @body.collection.trigger("saveAndRefresh")  
    , this)
    return model
