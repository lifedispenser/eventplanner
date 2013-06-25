class Backgrid.SortableCell extends Backgrid.StringCell
  render: ->
    @$el.empty();
    @$el.html("<div class='drag_wrapper'>" + @formatter.fromRaw(@model.get(@column.get("name"))) + " <p class='dragger'></p></div>")
    @delegateEvents();
    return this;