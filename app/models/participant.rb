# = Participant
# An object that is created to represent a user who signed up for a certain event.
# == Data
# [user] A reference to a User.
# [event] A reference to an Event.
# == Attributes
# * Belongs to a user
# * Belongs to an event
# * User must be present
# * Event must be present
# * User must have an unique combination with an event
class Participant < ActiveRecord::Base
  belongs_to :user
  belongs_to :event

  validates :user, presence: true
  validates :event, presence: true
  validates :user, uniqueness: {scope: :event}
end
