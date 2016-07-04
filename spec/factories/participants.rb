FactoryGirl.define do
  factory :participant do
    association :user, rank: 1
    association :event
  end
end
