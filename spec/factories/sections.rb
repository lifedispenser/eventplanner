# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :section do
    name "MyString"
    description "MyText"
    confirm 1
    order "MyString"
  end
end
