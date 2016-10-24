require 'rails_helper'

RSpec.describe Token, type: :model do
  let(:user) do
    FactoryGirl.create(:user)
  end

  it 'is valid with valid information' do
    token = Token.new(token: '1234', user_id: user.id)
    expect(token).to be_valid
  end

  it 'is not valid without a valid user' do
    token = Token.new(token: '1234', user_id: nil)
    expect(token).not_to be_valid
  end

  it 'is not valid without a valid token' do
    token = Token.new(token: nil, user_id: user.id)
    expect(token).not_to be_valid
  end
end
