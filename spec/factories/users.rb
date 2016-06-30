FactoryGirl.define do
  factory :user do
    name "John Doe"
    email "test@test.com"
    password_digest "password1234"
  end
end
