# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :course do
    name "Computing Science"
    description "Computing Science Master Degree"
    status 1
  end
end
