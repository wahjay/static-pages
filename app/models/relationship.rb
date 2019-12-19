class Relationship < ApplicationRecord
  # since relationships involve two users
  # a relationship belongs to both a follower and followed user
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end
