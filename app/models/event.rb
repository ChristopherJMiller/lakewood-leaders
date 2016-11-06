# = Event
# An object that represents a real world event within the website.
#
# == Data
# [name] A string that contains the event name.
# [description] A text field that contains the events description.
# [location] A string that contains the location of the event.
# [start_time] A datetime that contains the date and time for the beginning of the event.
# [end_time] A datetime that contains the date and time for the end of the event.
# [finished] A boolean that defines if the event is over or not.
# [max_participants] A number that defines the greatest number of participants for that event.
# == Attribute
# * Name must be present
# * Description must be present and has a maximum of 2048 characters
# * Location must be present and has a maximum of 256 characters
# * Start time must be present
# * End time must be present
# * Finished must be present and be true or false
class Event < ActiveRecord::Base
  validates :name, presence: true

  validates :description, presence: true
  validates :description, length: {maximum: 2048}

  validates :location, presence: true
  validates :location, length: {maximum: 256}

  validates :start_time, presence: true

  validates :end_time, presence: true

  validates :finished, inclusion: [true, false]

  validates :max_participants, presence: true
  validates :max_participants, numericality: {greater_than: 0}

  has_many :participants
  has_many :users, through: :participants

  def full
    participants.count >= max_participants
  end

  def slots_left
    max_participants - participants.count
  end
end
