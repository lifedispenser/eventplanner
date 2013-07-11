class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :confirmable, :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  has_many :events, :through => :event_users
  has_many :event_users
  has_many :owned_events, :through => :event_users, :source => :events, :conditions => { :level => 0 }

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :contacts
  # attr_accessible :title, :body
  validates_presence_of :email


  def contacts_sync (token)
    hash = {}
    GmailContacts::Google.new(token).all_contacts({}, 2000).each do |contact|
      if contact.name.nil? || contact.name == ""
        hash[contact.email] = contact.email 
      else
        hash[contact.email] = contact.name
      end
    end
    self.contacts = hash.to_json
    self.contacts_updated = Time.now
    self.save!
  end

  def contacts_autocomplete
    result = []
    return result if !self.contacts
    ActiveSupport::JSON.decode(self.contacts).each do |email, name|
      result.push({
        value: name + " " + email,
        label: name,
        email: email
        })
    end
    return result
  end
end