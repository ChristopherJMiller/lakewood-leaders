# = Event
# An object that represents a real world event within the website.
#
# == Data
# [name] A string that contains the event name.
# [description] A text field that contains the events description.
# [location] A string that contains the location of the event.
# [start_time] A datetime that contains the date and time for the beginning of the event.
# [end_time] A datetime that contains the date and time for the end of the event.
#
# == Attribute
# * Name must be present
# * Description must be present and has a maximum of 2048 characters
# * Location must be present and has a maximum of 256 characters
# * Start time must be present
# * End time must be present
class Event < ActiveRecord::Base

  validates :name, presence: true

  validates :description, presence: true
  validates :description, length: { maximum: 2048 }

  validates :location, presence: true
  validates :location, length: { maximum: 256 }

  validates :start_time, presence: true

  validates :end_time, presence: true
end
