class Tweet < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :user
  validates :text, length: { maximum: 140 }
  validates :text, presence: true

end
