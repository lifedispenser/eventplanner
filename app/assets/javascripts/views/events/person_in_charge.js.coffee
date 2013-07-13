class Eventplanner.Views.PersonInCharge extends Backbone.View

  events: 
    "click #section-email": "openMenu"
    "click .sync": "syncContacts"
    "click .send": "openReminders"
    "click .auto": "autoEmailToggle"

  initialize: (options) ->
    @grid = options.grid

  render: ->
    return false if Eventplanner.user is null or @grid.collection.event.get("owner") is undefined
    return false if @grid.collection.event.get("owner").id != Eventplanner.user.id
    @$el = $("a:contains('Person in Charge')").parents("th")
    @$el.append("
      <div id='section-email'>
        <ul class='ui-menu menu-settings'>
          <li><a class='sync'>Sync Contacts</a></li>
          <li><a class='send'>Send Reminder Emails</a></li>
        </ul>
      </div>
      ")
    @$el.append('
      <div id="email-reminders" title="Send Email Reminders"> 
        <h3> Send Emails to: </h3>
        <table class="backgrid">
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Incomplete Items</th>
            <th>Days Left</th>
            <th>&#x2713;</th>
          </tr>
        </table>
        <br>
        <input type="submit" class="btn sendemails" value="Send Emails"> 
      </div>')
    $("#email-reminders").dialog({
      autoOpen: false
      modal: true
      width: 900
    })
    @delegateEvents()


    return this


  openMenu: (e) ->
    $(e.target).parent()[0].style.overflow = 'visible'
    menu = $(e.target).find(".menu-settings")
    if menu.length > 0
      menu[0].style.display = 'block'
      menu[0].style.width = $(e.target).parent().width() + "px"

  syncContacts: () ->
    window.location = "http://"+window.location.host+"/users/contacts_sync?location=" + window.location.href

  openReminders: () ->
    daydiff = (first, second) ->
      return Math.round((second-first)/(1000*60*60*24))
    $("#email-reminders table tr:not(:first-child)").remove();
    $("#email-reminders").dialog('open')
    $("#email-reminders .sendemails").off("click")
    $("#email-reminders .sendemails").on("click", @grid, @sendReminders)

    people = new Object();
    grid = @grid
    @grid.collection.each((item) ->
      if(item.get("status") != "completed" && item.get("person_in_charge") != "" && item.get("person_in_charge") != null)
        people[item.get("person_in_charge")] ||= {
          count: 0
          days_until_due: 10000000000000
        }
        people[item.get("person_in_charge")]['count'] += 1
        if _.isNumber(item.get("days_before")) and moment(item.collection.event.get('date'))
          today = moment()
          due_date = moment(grid.collection.event.get("date")).subtract('days', parseInt(item.get("days_before")))
          days_until_due = daydiff(today, due_date) 
          people[item.get("person_in_charge")]['days_until_due'] = days_until_due if days_until_due < people[item.get("person_in_charge")]['days_until_due']
    )
    rows = ""
    _.each(people, (data, email) ->
      email = JSON.parse(email)
      data['days_until_due'] = ">10" if data['days_until_due'] > 10
      rows += "
        <tr>
          <td>#{email['name']}</td>
          <td>#{email['email']}</td>
          <td>#{data['count']} Items</td>
          <td>#{data['days_until_due']} days until due</td>
          <td><input type='checkbox' checked></td>
        </tr>
        "
    )
    $("#email-reminders table").append(rows)

    
  sendReminders: (e) ->
    receivers = _.map($("#email-reminders input:checked"), (input) ->
      $(input).parents("tr").find("td:nth-child(2)").text()
    )
    data = {
      'id': e.data.collection.event.get("id")
      'receivers': receivers.join(",")
    }
    $.ajax({
      type: "POST"
      url: "/mail/send_reminders"
      data: data
      dataType: 'json'
      success : (json) ->
        $("#section-messages").html("
          <div id='flash_notice'> Emails Sent.</div>
          ")
      }) 
    $("#email-reminders").dialog("close")
    return false
    

     