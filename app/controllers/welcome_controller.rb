class WelcomeController < ApplicationController
  skip_before_action :require_login, only: [:home]
  
  def home
    #session.raise.inspect
    #binding.pry
    redirect_to user_path(current_user) if logged_in
  end
end
