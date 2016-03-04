class Friendship < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :leader, {class_name: "User"}
  belongs_to :follower, {class_name: "User"}

  # This ensures that a leader can only be followed once by a follower and a follower can only follow a leader once
   validates :leader_id, uniqueness: {scope: :follower_id}
   validates :follower_id, uniqueness: {scope: :leader_id}
end
