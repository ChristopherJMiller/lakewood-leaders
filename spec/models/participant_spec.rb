require 'rails_helper'

RSpec.describe Participant, type: :model do
  let(:user) do
    FactoryGirl.create(:user)
  end

  let(:event) do
    FactoryGirl.create(:event)
  end

  it 'is valid with valid information' do
    participant = Participant.new(user_id: user.id, event_id: event.id)
    expect(participant).to be_valid
  end

  it 'is not valid with a missing user' do
    participant = Participant.new(user_id: nil, event_id: event.id)
    expect(participant).not_to be_valid
  end

  it 'is not valid with a missing event' do
    participant = Participant.new(user_id: user.id, event_id: nil)
    expect(participant).not_to be_valid
  end

  it 'is not valid with an invalid name' do
    participant = Participant.new(user_id: 1, event_id: event.id)
    expect(participant).not_to be_valid
  end

  it 'is not valid with an invalid event' do
    participant = Participant.new(user_id: user.id, event_id: 1)
    expect(participant).not_to be_valid
  end

  it 'is not valid with an existing name and event combinaition' do
    Participant.create(user_id: user.id, event_id: event.id)
    participant = Participant.new(user_id: user.id, event_id: event.id)
    expect(participant).not_to be_valid
  end
end
