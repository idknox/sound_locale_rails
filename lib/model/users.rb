require "date"
require "active_record"

class User < ActiveRecord::Base
  validates :email, :uniqueness => {
    :message => "is already linked to an account"
  }
  validates :password, :confirmation => {
    :message => "must match password"
  }

  validate do
    errors.add(:birthday, "must be over 13") if age < 13
  end

  def self.is_admin?(id)
    id == 1
  end

  private

  def age
    # bday = Date.parse(birthdate)
    now = Time.now.utc.to_date
    now.year - birthday.year - ((now.month > birthday.month || (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
  end

end