class Item < ActiveRecord::Base
  attr_accessible :completed_by, :days_before, :description, :child, :person_in_charge, :result, :status
  
  belongs_to :event
  belongs_to :parent, :class_name => 'Item'
  belongs_to :section
end
