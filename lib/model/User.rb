require "date"
require "active_record"

class User < ActiveRecord::Base

  def self.is_admin(id)
    id == 1
  end

end