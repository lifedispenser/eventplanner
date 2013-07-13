class Eventplanner.Collections.Items extends Backbone.OrderableCollection

  model: Eventplanner.Models.Item
  url: "/items"

  order: ->
    if !(_.isUndefined(@event.get("order")) or @event.get("order") is "" or @event.get("order") is null)
      order = @event.get("order").split(",")
      _.each(order, (id) -> 
        model = @get(id)
        @remove(model)
        @push(model)
      , this)