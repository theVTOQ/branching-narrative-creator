class UsersController < ApplicationController
    before_action :find_user
    skip_before_action :find_user, only: [:new, :create, :index]
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
        if current_user.id != @user.id 
            unless current_user.admin
                redirect_to user_path(current_user), alert: "Access Denied"
            end
        end
        @new_narrative = Narrative.new
    end

    def index
        if current_user.nil?
            redirect_to "/"
        elsif !current_user.admin
            redirect_to user_path(current_user), alert: "You do not have access to the User database."
        end

        @users = User.all
    end

    private

    def user_params
        params.require('user').permit('name', 'email', 'password', 'admin')
    end

    def find_user
        @user = User.find_by(id: params[:id])
    end
end