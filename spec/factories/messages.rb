FactoryGirl.define do
  factory :message do
    association :user
    subject "Test Subject"
    body "Test Body"
  end
end
