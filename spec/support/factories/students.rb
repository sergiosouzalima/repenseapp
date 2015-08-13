# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :student do
    name "John Smith"
    register_number "12345678"
    status 1
  end
end
