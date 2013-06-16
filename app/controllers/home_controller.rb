class HomeController < ApplicationController
  def index
  	redirect_to "/events" if current_user
	end
end
