class Friendship < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :leaders, {class_name: "User"}
  belongs_to :followers, {class_name: "User"}
end
