class Eventplanner.Views.EventTools extends Backbone.View
  template: JST['events/event_tools']

  events: 
    "click .export" : 'exportTemplate'

  render: ->
    @setElement(@template())
    return @

  setupFunctionality: (id) ->
    $("#export-form form").off("submit")
    $("#export-form").dialog({
      autoOpen: false,
      modal: true
    })
    $("#export-form form input[name='id']").val(id)
    $("#export-form form").on("submit", () ->
      $.ajax({
      type: "POST"
      url: "/save_template"
      data: $(this).serializeArray()
      dataType: 'json'
      success : (json) ->
        window.router.templates.add(json)
        $("#section-messages").html("
          <div id='flash_notice'> Template Exported.</div>
          ")
      }) 
      $("#export-form").dialog("close")
      return false
    )


  submitForm: (e) ->
    
  exportTemplate: () ->
    $( "#export-form" ).dialog('open')
 
