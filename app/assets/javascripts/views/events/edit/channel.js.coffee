class Eventplanner.Views.Events.Edit.Channel extends Backbone.View

  events:
    "click" : "openMenu"

  initialize: (options) ->
    @$el = $(".login")
    @members = []
    @pusher = options.pusher
    @pusher.unsubscribeAll()
    @channel = @pusher.subscribe(options.name)
    that = this
    @channel.bind('pusher:subscription_succeeded', (members) ->
      that.updateCount(members.count-1)
      that.updateMembers(members)
    )
    @channel.bind('pusher:member_added', (member) ->
        that.updateCount(that.members.count-1)
        that.updateMembers(that.members) 
    )
    
    @channel.bind('pusher:member_removed', (member) ->
      that.updateCount(that.members.count-1)
      that.updateMembers(that.members) 
    )

    @delegateEvents()


  updateCount: (count) ->
    @count = count
    if @count > 0
      @$el.find(".count").text("+" + count + " editing")
    else
      @$el.find(".count").text("")

  updateMembers: (members) ->
    @members = members
    that = this
    member_html = ""
    @members.each((member) ->
      member_html += "<li>" + member.info.email + "</li>" unless member.info.email == that.members.me.info.email
    )
    @$el.find('.members li').slice(1).remove()
    @$el.find('.members ul').append(member_html)
    
  render: ->
    @updateCount(@count)
    @updateMembers(@members)
    return @$el

