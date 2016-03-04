require 'bcrypt'

class User < ActiveRecord::Base
  has_many :tweets
  validates :first_name, :last_name, :user_name, :email, :encrypted_password, :location, presence: true
  validates :user_name, :email, uniqueness: true

  def password
    @password ||= BCrypt::Password.new(encrypted_password)
  end

  def password=(new_password)
    @password = BCrypt::Password.create(new_password)
    self.encrypted_password = @password
  end

  def authenticate(poss_pass)
    self.password == poss_pass
  end
end
