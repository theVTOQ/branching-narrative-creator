class UsersController < ApplicationController
    before_action :find_user
    skip_before_action :find_user, only: [:new, :create]
    skip_before_action :require_login, only: [:new, :create]

    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:email] = @user.email
            redirect_to user_path(@user)
        else
            render "new"
        end
    end

    def show
        if @user.nil? 
            redirect_to "/", alert: "Access Denied."
        elsif current_user.id != @user.id
            redirect_to user_path(current_user), alert: "Access Denied"
        else
            @user = User.find_by(id: params[:id])
            @new_narrative = Narrative.new(user_id: @user.id)
        end
    end

    private

    def user_params
        params.require('user').permit('name', 'email', 'password', 'admin')
    end

    def find_user
        @user = User.find_by(email: session[:email])
    end
end