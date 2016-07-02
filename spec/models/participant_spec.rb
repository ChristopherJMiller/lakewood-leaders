require 'rails_helper'

RSpec.describe Participant, type: :model do

  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:event) do
    FactoryGirl.create(:event)
  end

  it 'should be valid with valid information' do
    participant = Participant.new(user_id: user.id, event_id: event.id)
    expect(participant).to be_valid
  end

  it 'should not valid with a missing user' do
    participant = Participant.new(user_id: nil, event_id: event.id)
    expect(participant).to_not be_valid
  end

  it 'should not valid with a missing event' do
    participant = Participant.new(user_id: user.id, event_id: nil)
    expect(participant).to_not be_valid
  end

  it 'should not valid with an invalid name' do
    participant = Participant.new(user_id: 1, event_id: event.id)
    expect(participant).to_not be_valid
  end

  it 'should not valid with an invalid event' do
    participant = Participant.new(user_id: user.id, event_id: 1)
    expect(participant).to_not be_valid
  end

  it 'should not valid with an existing name and event combinaition' do
    Participant.create(user_id: user.id, event_id: event.id)
    participant = Participant.new(user_id: user.id, event_id: event.id)
    expect(participant).to_not be_valid
  end
end
