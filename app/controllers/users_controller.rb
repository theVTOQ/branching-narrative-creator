class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:name] = @user.name
            redirect_to user_path(@user)
        else
            render "new"
        end
    end

    def show
        @user = User.find_by(id: params[:id])
        return head(:forbidden) if @user.nil? || current_user.id != @user.id
    end

    private

    def user_params
        params.require('user').permit('name', 'email', 'password')
    end
end