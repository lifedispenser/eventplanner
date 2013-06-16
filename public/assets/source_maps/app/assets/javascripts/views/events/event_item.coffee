class Eventplanner.Views.EventItem extends Backbone.View
  template: JST['events/item']

  events:
    "click td.edit-cell .val" : "toggleInput"
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()
    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this

  toggleInput: (ev) -> 
    console.log(ev)
    parent = $(ev.target).parent('td');
    value = $(ev.target).text();
    input = $("<input type='text' value=#{value} >")
    parent.html(input)
    input.focus()
