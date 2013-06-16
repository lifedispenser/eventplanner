class Eventplanner.Models.Event extends Backbone.RelationalModel
  paramRoot: 'event'

  relations: [{
  	type: Backbone.hasMany
  	key: "event_id"
  	relatedModel: "Item"
  	collectionType: "ItemsCollection"
  	}]

  defaults:
    name: null
    location: null
    date: null

class Eventplanner.Collections.EventsCollection extends Backbone.Collection
  model: Eventplanner.Models.Event
  url: '/events'
