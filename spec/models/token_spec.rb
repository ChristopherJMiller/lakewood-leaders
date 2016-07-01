require 'rails_helper'

RSpec.describe Token, type: :model do
  let(:user) do
    FactoryGirl.create(:user)
  end

  it 'should be valid with valid information' do
    token = Token.new(token: '1234', user_id: user.id)
    expect(token).to be_valid
  end

  it 'should not be valid without a valid user' do
    token = Token.new(token: '1234', user_id: nil)
    expect(token).to_not be_valid
  end

  it 'should not be valid without a valid token' do
    token = Token.new(token: nil, user_id: user.id)
    expect(token).to_not be_valid
  end
end
