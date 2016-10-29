FactoryGirl.define do
  factory :message do
    association :user, email: 'message@test.com'
    subject 'Test Subject'
    body 'Test Body'
  end
end
