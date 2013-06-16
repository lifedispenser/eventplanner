def new_event
  @event ||= { :date => Date.today, :location => "here",
    :name => "New Event 1" }
end

When(/^I create an event$/) do
	new_event
  @event = @user.events.build(@event)
  @event.save && @event.event_users.create(:user_id => @user.id, :level => 0)
end

Then(/^I should be a user of the event$/) do
  !@event.users.all.find_index(@user).nil?
end

Then(/^I should an owner of the event$/) do
  @event.owner == @user
end

Given(/^My friend exists as a user$/) do
  create_visitor
  delete_user
  @friend = FactoryGirl.create(:user, @visitor)
  @friend.confirm!
end

When(/^I add a friend to the event$/) do
  @event.users << @friend
  @event.save!
end

Then(/^He should be a user of the event$/) do
  !@event.users.all.find_index(@friend).nil?
end

Then(/^He should not be an owner of the event$/) do
  @event.owner != @friend
end
