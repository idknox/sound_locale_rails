module EventHelper
  def formatted_date(date)
    if date == DateTime.now.tomorrow.to_date
      'Tomorrow'
    elsif date == Date.today
      'Today'
    else
      date.strftime('%A, %B %e')
    end
  end

  def formatted_time(time)
    time.in_time_zone('Mountain Time (US & Canada)').strftime('%l:%M %p') if time
  end

  def doors(time)
    formatted_time(time.advance(hours: -1))
  end

  def truncated_string(string)
    string.length > 35 ? string[0,35]+'...' : string
  end
end