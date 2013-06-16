class Backgrid.orderableBody extends Backgrid.Body
  events:
    "mouseover": "showDragger"
    "click" : "captureEvent"

  showDragger: (e) ->
    tr = $(e.target).parents('tr');
    return if tr.find("th").length > 0 or tr.hasClass(".has_dragger")
    $(".has_dragger").removeClass("has_dragger")
    tr.addClass("has_dragger")
    $(".dragger").remove() if $(".dragger").length > 0
    dragger = $("<p class='dragger'></p>")
    dragger.height($(tr).height())
    dragger.offset($(tr).offset())
    tr.find("td:first-child").append(dragger)


class Backgrid.orderableGrid extends Backgrid.Grid
  body: Backgrid.orderableBody


