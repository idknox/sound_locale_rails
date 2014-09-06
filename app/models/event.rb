require "open-uri"
require "json"
require "time"
require "net/http"

class Event < ActiveRecord::Base
  belongs_to :venue

  validates :date, :uniqueness => {:scope => :venue_id}
end
