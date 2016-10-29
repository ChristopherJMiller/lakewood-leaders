FactoryGirl.define do
  factory :event do
    name 'My Event'
    description 'This is a description'
    location '1234 Street St. New York, USA'
    start_time '2016-07-01 23:57:29'
    end_time '2016-07-02 23:57:29'
    finished false
    max_participants 1
  end
end
