class ReminderMailer < ActionMailer::Base
  default from: "mailer@churchlifeeventplanning.org"

  def reminder_email (data)
    @receiver = data[:receiver]
    @event = data[:event]
    @url = data[:url]
    mail(to: @receiver, subject: @event.name + "planning")
  end

  def share_email (data)
  end
end
