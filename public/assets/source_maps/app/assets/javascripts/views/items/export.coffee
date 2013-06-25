class Eventplanner.Views.ExportItems extends Backbone.View
  tagName: 'td'
  className: "tools"
  events:
    "click .export" : exportCheckboxes
    "click .import" : importSection
  

