class Backgrid.UseCell extends Backgrid.Cell

  events: {
    "click" : "addEventFromTemplate"
  }

  render: ->
    @$el.empty()
    @$el.addClass("use-cell")
    @$el.attr("model_id", @model.get("id"))
    @$el.html("Use Template");
    @delegateEvents();
    return this

  addEventFromTemplate: (e) ->
    $.ajax({
      type: "POST"
      url: "/load_template"
      data: {"id": @model.get("id")}
      dataType: 'json'
      success : (json) ->
        window.router.events.add(json)
        window.location = "http://"+window.location.host+"/events#"+json.id
      }) 