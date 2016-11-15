require 'rails_helper'

RSpec.describe User, type: :model do
  it 'is a valid user' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).to be_valid
  end
  it 'is not valid with a missing name' do
    user = User.new(name: nil, email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with a missing email' do
    user = User.new(name: 'John Doe', email: nil, password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with an invalid email' do
    user = User.new(name: 'John Doe', email: 'testtest.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with a mismatched password' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password12345', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with a duplicate email' do
    User.create(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with an unroutable email' do
    user = User.new(name: 'John Doe', email: 'test@localhost', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with a missing password' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: nil, password_confirmation: nil, verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with a short password' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'pass', password_confirmation: 'pass', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with an undefined verified' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: nil, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with an undefined rank' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: nil, parent_email: 'parent@test.com', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is valid with a missing parent email' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: nil, parent_verified: true, parent_verify_token: '')
    expect(user).to be_valid
  end
  it 'is not valid with an invalid parent email' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'notcorrectemail', parent_verified: true, parent_verify_token: '')
    expect(user).not_to be_valid
  end
  it 'is not valid with an invalid parent verified' do
    user = User.new(name: 'John Doe', email: 'test@test.com', password: 'password1234', password_confirmation: 'password1234', verified: true, verify_token: '', rank: 0, parent_email: 'parent@test.com', parent_verified: nil, parent_verify_token: '')
    expect(user).not_to be_valid
  end
end
