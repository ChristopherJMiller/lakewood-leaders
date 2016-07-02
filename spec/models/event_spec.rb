require 'rails_helper'

RSpec.describe Event, type: :model do

  it 'should be valid with valid information' do
    event = Event.new(name: 'Event', description: 'Event description', location: '1234 Street St. New York, USA', start_time: '2016-07-01 23:57:29', end_time: '2016-07-01 23:57:29')
    expect(event).to be_valid
  end

  it 'should not valid with a missing name' do
    event = Event.new(name: nil, description: 'Event description', location: '1234 Street St. New York, USA', start_time: '2016-07-01 23:57:29', end_time: '2016-07-01 23:57:29')
    expect(event).to_not be_valid
  end

  it 'should not valid with a missing description' do
    event = Event.new(name: 'Event', description: nil, location: '1234 Street St. New York, USA', start_time: '2016-07-01 23:57:29', end_time: '2016-07-01 23:57:29')
    expect(event).to_not be_valid
  end

  it 'should not valid with a missing location' do
    event = Event.new(name: 'Event', description: 'Event description', location: nil, start_time: '2016-07-01 23:57:29', end_time: '2016-07-01 23:57:29')
    expect(event).to_not be_valid
  end

  it 'should not valid with a missing start time' do
    event = Event.new(name: 'Event', description: 'Event description', location: '1234 Street St. New York, USA', start_time: nil, end_time: '2016-07-01 23:57:29')
    expect(event).to_not be_valid
  end

  it 'should not valid with a missing end time' do
    event = Event.new(name: 'Event', description: 'Event description', location: '1234 Street St. New York, USA', start_time: '2016-07-01 23:57:29', end_time: nil)
    expect(event).to_not be_valid
  end

  it 'should not valid with an invalid description' do
    event = Event.new(name: 'Event', description: '0' * 2049, location: '1234 Street St. New York, USA', start_time: '2016-07-01 23:57:29', end_time: '2016-07-01 23:57:29')
    expect(event).to_not be_valid
  end
end
