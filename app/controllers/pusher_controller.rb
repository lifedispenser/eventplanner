class PusherController < ApplicationController
  def auth
    if current_user
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => current_user.id,
        :user_info => {
          :email => current_user.email
        }
      })
      render :json => response
    else
      # We're allowing anonymous users
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => guest_user.email[0..11].to_int,
        :user_info => {
          email: guest_user.email[0..11]
        }
      })
      render :json => response
    end
  end
end