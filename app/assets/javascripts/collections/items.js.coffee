class Eventplanner.Collections.Items extends Backbone.OrderableCollection

  model: Eventplanner.Models.Item
  url: "/items"

  comparator: (collection) ->
    return collection.get("ranked")
