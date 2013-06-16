# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :item do
    description "MyString"
    result "MyString"
    person_in_charge ""
    completed_by "2013-05-14"
    days_before ""
    status "MyString"
    parent ""
  end
end
