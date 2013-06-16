class EventUser < ActiveRecord::Base
  attr_accessible :event_id, :level, :user_id
  belongs_to :event
  belongs_to :user
end
