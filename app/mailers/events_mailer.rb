class EventsMailer < ActionMailer::Base
  default from: "Sound Locale"

  def ticketfly_pull(event_count)
    @event_count = event_count
    mail(to: 'knoxid@gmail.com', subject: 'Ticketfly Event Pull')
  end
end
