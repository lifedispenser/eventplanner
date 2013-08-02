Pusher::unsubscribeAll = () ->
  for id of @channels.channels
    @unsubscribe(id)
