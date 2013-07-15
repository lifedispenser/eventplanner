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
        flash[:notice] = 'Contacts successfully synced. Autocomplete should be working now.'
        if session[:return_to]
          redirect_to session[:return_to]
          session[:return_to] = nil
        else 
          redirect_to "/events"
        end
      rescue Exception => e
      end
    end
    @hash = current_user.contacts
  end

  def contacts_sync
    session[:return_to] = params[:location] + "#" + params[:hash] if params[:location]
    redirect_to GmailContacts::Google.authentication_url(users_contacts_url)
  end
end
