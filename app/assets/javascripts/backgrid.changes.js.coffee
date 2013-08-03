Backgrid.Cell::render = () ->
  @$el.empty()
  if @formatter.fromRaw(@model.get(@column.get("name"))) is "" and @column.get("placeholder")
    @$el.html("<span class='placeholder'>" + @column.get("placeholder") + "</span>")
  else
    @$el.text(@formatter.fromRaw(@model.get(@column.get("name"))))
  if @formatter.fromRaw(@model.get(@column.get("name"))) != ""
    @$el.attr("title", @formatter.fromRaw(@model.get(@column.get("name"))))
  @delegateEvents()
  return @