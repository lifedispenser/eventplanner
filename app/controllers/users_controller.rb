class UsersController < ApplicationController
	before_filter :authenticate_user!

  def index
  	@users = User.all
  end

  def show
  	@user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @user.id != current_user.id
        format.html { redirect_to '/events' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      elsif @user.update_attributes(params[:user].slice(*User.accessible_attributes.to_a))
        notice = ''
        if params[:user][:password]
          sign_in(@user, :bypass => true)
          notice = 'Password changed.'
        else
          notice = 'Successfully updated your information.'
        end
        format.html { 
          flash[:notice] = notice
          redirect_to '/events'
        }
        format.json { head :no_content }
      else        
        format.html { 
          flash[:alert] = "There was a problem updating your password. Please try again."
          redirect_to '/events'
        }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
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
