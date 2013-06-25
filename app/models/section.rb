class Section < ActiveRecord::Base
  attr_accessible :confirm, :description, :name, :order

  has_many :items
  
end
