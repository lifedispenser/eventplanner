# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event_user, :class => 'EventUsers' do
    event_id ""
    user_id ""
    level ""
  end
end
