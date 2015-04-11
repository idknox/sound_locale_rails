module EventHelper
  def formatted_date(date)
    if date == DateTime.now.tomorrow.to_date
      'Tomorrow'
    elsif date == Date.today
      'Today'
    else
      date.strftime('%A, %b %e')
    end
  end

  def formatted_time(time)
    time.in_time_zone('Mountain Time (US & Canada)').strftime('%l:%M %p') if time
  end

  def doors(time)
    formatted_time(time.advance(hours: -1))
  end

  def truncated_string(string)
    string.length > 35 ? string[0, 35]+'...' : string
  end

  def next_12_months
    current_month = Date.today.month
    current_year = Date.today.year
    names = %w(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)

    months = names.map.with_index do |name, i|
      {
        name: name,
        index: i+1,
        year: i+1 > current_month ? current_year : current_year+1
      }
    end

    months[current_month..-1] + months[0...current_month]
  end

  def dates(events)
    events.map { |event| formatted_date(event.date) }
  end

  def next_months(months)
    (Date.today..Date.today.advance(months: +months)).inject({}) { |dates, date| dates.merge({formatted_date(date) => date}) }
  end
end