class Event < ActiveRecord::Base
  attr_accessible :date, :location, :name, :order, :template_title, :template_desc
  
  has_many :event_users
  has_many :users, :through => :event_users
  def owner
  	event_users.where(:level => 0).first.user
  end
  def owner=(user)
    self.event_users.build(user_id: user.id, :level => 0)
  end
  has_many :items
	accepts_nested_attributes_for :items, allow_destroy: true


  def generate_event_code (email)
    string = self.id.to_s + "|zq|" + email    
    return Base64.urlsafe_encode64(string)
  end

  amoeba do
    include_field :items
  end

end