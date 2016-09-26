class Message < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true
  validates :subject, presence: true
  validates :body, presence: true
  validates :subject, length: { minimum: 1, maximum: 128 }
  validates :body, length: { maximum: 2048 }
end
