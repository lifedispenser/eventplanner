class UsersController < ApplicationController
	before_filter :authenticate_user!

  def index
  	@users = User.all
  end

  def show    
  	@user = User.find(params[:id])
  end

  def contacts
    if params[:token]
      begin     
        current_user.contacts_sync params[:token]   
      rescue Exception => e
      end
    end
    @hash = current_user.contacts
  end

  def contacts_sync
    redirect_to GmailContacts::Google.authentication_url("http://localhost:3000/users/contacts")
  end
end
