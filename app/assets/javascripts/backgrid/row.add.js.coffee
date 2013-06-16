Backgrid.Grid::insertAddRow = (text) ->
  return @body.el.appendChild(new Backgrid.AddRow({
    emptyText: text
    columns: @body.columns
    grid: this
  }).render())

class Backgrid.AddRow extends Backgrid.EmptyRow
  initialize: (options) ->
    Backgrid.requireOptions(options, ["emptyText", "columns", "grid"])
    @grid = @options.grid
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
    model = @grid.collection.create({
      event_id: @grid.collection.event.get('id')
    }, {wait: true})
    @$el.trigger("saveAndRefresh")
    return model