class User < ActiveRecord::Base

  has_secure_password

  validates :email, presence: true, uniqueness: {case_sensitive: false}

  def self.get_names
    all.to_a.map { |user| user.name }
  end

  def is_admin?(user)
    user.id == 1
  end
end
