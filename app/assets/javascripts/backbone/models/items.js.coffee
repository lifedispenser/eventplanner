class Eventplanner.Models.Items extends Backbone.Model
  paramRoot: 'item'

  defaults:
    description: null
    result: null
    completed_by: null
    days_before: null
    parent: null
    person_in_charge: null
    status: null

class Eventplanner.Collections.ItemsCollection extends Backbone.Collection
  model: Eventplanner.Models.Items
  url: '/items'
