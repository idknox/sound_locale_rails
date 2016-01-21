class Event < ActiveRecord::Base
  belongs_to :venue

  validates :show_start, :uniqueness => {:scope => :venue_id}

  def formatted_time
    time.strftime("%l:%M")
  end
end
