require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) do
    FactoryGirl.create(:user)
  end

  it 'is valid with valid information' do
    message = Message.new(user_id: user.id, subject: 'Test Message', body: 'Test Body')
    expect(message).to be_valid
  end

  it 'is not valid with a missing recipient information' do
    message = Message.new(user_id: nil, subject: 'Test Message', body: 'Test Body')
    expect(message).not_to be_valid
  end

  it 'is not valid with a missing subject' do
    message = Message.new(user_id: user.id, subject: nil, body: 'Test Body')
    expect(message).not_to be_valid
  end

  it 'is not valid with a missing body' do
    message = Message.new(user_id: user.id, subject: 'Test Message', body: nil)
    expect(message).not_to be_valid
  end
end
