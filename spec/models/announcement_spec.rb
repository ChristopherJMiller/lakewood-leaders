require 'rails_helper'

RSpec.describe Announcement, type: :model do

  let(:user) do
    FactoryGirl.create(:user)
  end

  it 'should be valid with valid information' do
    announcement = Announcement.new(title: 'Test Announcement', post: 'Hello World!', user_id: user.id)
    expect(announcement).to be_valid
  end

  it 'should not be valid with a missing title' do
    announcement = Announcement.new(title: nil, post: 'Hello World!', user_id: user.id)
    expect(announcement).to_not be_valid
  end

  it 'should not be valid with an invalid title' do
    announcement = Announcement.new(title: '0' * 65, post: 'Hello World!', user_id: user.id)
    expect(announcement).to_not be_valid
  end

  it 'should not be valid with a missing post' do
    announcement = Announcement.new(title: 'Test Announcement', post: nil, user_id: user.id)
    expect(announcement).to_not be_valid
  end

  it 'should not be valid with an invalid post length' do
    announcement = Announcement.new(title: 'Test Announcement', post: '0' * 1025, user_id: user.id)
    expect(announcement).to_not be_valid
  end

  it 'should not be valid with a missing author' do
    announcement = Announcement.new(title: 'Test Announcement', post: 'Hello World!', user_id: nil)
    expect(announcement).to_not be_valid
  end
end
