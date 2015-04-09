module EventHelper
  def formatted_date(date)
    date == DateTime.now.tomorrow.to_date ? 'Tomorrow' : date.strftime('%A, %B %e')
  end
end