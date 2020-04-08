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
        #if found_user_is_logged_in 
        #    unless current_user.admin
        #        redirect_to user_path(current_user), alert: "Access Denied"
        #    end
        #end
        @new_narrative = Narrative.new
    end

    def index
        #require admin access to see a list of all users
        unless current_user.admin
            redirect_to user_path(current_user), alert: "You do not have access to the User database."
        end

        @users = User.all
    end

    def destroy
        session.clear if found_user_is_logged_in
        @user.destroy
        redirect_to "/"
    end

    private

    def user_params
        params.require('user').permit('name', 'email', 'password', 'admin')
    end

    def find_user
        @user = User.find_by(id: params[:id])
        if @user.nil?
            #user not found
            redirect_to user_path(current_user), alert: "Access Denied."
        end

        unless found_user_is_logged_in
            #found user is not logged in
            unless current_user.admin
                #unless the logged-in user is an admin, redirect with an error
                redirect_to user_path(current_user), alert: "You do not have access to the User database."
            end
        end
    end

    def found_user_is_logged_in
        @user.id == current_user.id
    end

    helper_method :found_user_is_logged_in
end