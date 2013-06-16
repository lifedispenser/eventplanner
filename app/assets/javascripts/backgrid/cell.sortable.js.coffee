class Backgrid.SortableCell extends Backgrid.StringCell
  render: ->
    @$el.empty();
    @$el.html(@formatter.fromRaw(@model.get(@column.get("name"))) + " <p class='dragger'></p>")
    @delegateEvents();
    return this;