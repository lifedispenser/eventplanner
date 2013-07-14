class MailController < ApplicationController
  
  def reminder_email
    @event = Event.find(Event.id_from_code(params[:id]))
    @receivers = params[:receivers].split(",")

    @receivers.each do |receiver|
      data = {
        :receiver => receiver,
        :event => @event,
        :url => request.host + "/events#" + @event.generate_event_code
      }
      ReminderMailer.reminder_email(data).deliver
      respond_to do |format|
        format.json { head :no_content }
      end
    end
  end
end
