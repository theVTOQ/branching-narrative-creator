class SessionsController < ApplicationController
  # This is required because of a quirk the "developer" authentication
  # strategy. We'll remove this when we move to a "real" provider.
  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :require_login, only: [:new, :create, :destroy]

  def new
  end

  def create
    #binding.pry
    if params[:email].nil?
      #omniauth Github strategy:
      omniauth_data = request.env['omniauth.auth']
      name = omniauth_data[:info][:name]
      email = omniauth_data[:info][:email]
      user = User.find_by(uid: omniauth_data[:uid])
      if user.nil?
        user = User.new
        user.apply_omniauth(omniauth_data)
        user.save
      end
      session[:user_id] = user.id
      session[:omniauth_data] = omniauth_data
      redirect_to root_path
    else
      user = User.find_by(email: params[:email])
      if user.nil?
        redirect_to "/signin", alert: "No such email found."
      elsif user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to user_path(user)
      else
        flash[:notice] = "Incorrect password."
        redirect_to "/signin", alert: "Incorrect password."
      end
    end
  end

  def destroy
   # params.raise.inspect
    session.clear
    redirect_to root_url
  end
end
