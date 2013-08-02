class Item < ActiveRecord::Base
  include RankedModel
  
  attr_accessible :completed_by, :days_before, :description, :child, :person_in_charge, :result, :status, :ranked
  
  belongs_to :event
  ranks :ranked,
    :with_same => :event_id
  belongs_to :parent, :class_name => 'Item'
  belongs_to :section
end