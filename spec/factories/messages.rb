FactoryGirl.define do
  factory :message do
    association :user, email: 'message@test.com', rank: 2
    subject 'Test Subject'
    body 'Test Body'
  end
end
