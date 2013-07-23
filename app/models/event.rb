class Event < ActiveRecord::Base
  attr_accessible :date, :location, :name, :order, :template_title, :template_desc
  
  has_many :event_users, :dependent => :delete_all
  has_many :users, :through => :event_users
  def owner
  	event_users.where(:level => 0).first.user
  end
  def owner=(user)
    self.event_users.build(user_id: user.id, :level => 0)
  end
  has_many :items
	accepts_nested_attributes_for :items, allow_destroy: true


  def code_from_id
    string = self.id.to_s
    return Base64.urlsafe_encode64(string.encrypt)
  end

  def self.id_from_code(code)
    return Base64.urlsafe_decode64(code).decrypt.to_i
  end

  def as_json(options = { })
    h = super(options)
    h[:id] = code_from_id
    h
  end

  amoeba do
    include_field :items
  end

  def dup_as_template (current_user, title = nil, desc = nil)
    original = self
    original.template_title = title if title
    original.template_desc = desc if desc

    new_template = original.dup
    new_template.template = current_user ? current_user.id : -1
    new_template.name = ""
    new_template.location = ""
    new_template.date = nil
    new_template.save
    if original.items.length > 0
      ids = original.items.map { |item| item.id }
      new_order = []
      original.order.split(',').each do |id|
        new_item = original.items.at(ids.index(id.to_i)).dup
        new_item.event_id = new_template.id
        new_item.result = ""
        new_item.status = ""
        new_item.person_in_charge = ""
        new_item.save
        new_order.push(new_item.id)
      end
      new_template.order = new_order.join(",")
    end 

    new_template.save
    return new_template

  end

  def dup_as_event (current_user)
    original = self
    new_event = original.dup
    new_event.template = nil
    new_event.template_title = ""
    new_event.template_desc = ""
    new_event.owner = current_user if current_user
    new_event.save

    if original.items.length > 0
      ids = original.items.map { |item| item.id }
      new_order = []
      original.order.split(',').each do |id|
        new_item = original.items.at(ids.index(id.to_i)).dup
        new_item.event_id = new_event.id
        new_item.save
        new_order.push(new_item.id)
      end
      new_event.order = new_order.join(",")
    end
    new_event.save
    return new_event
  end

end