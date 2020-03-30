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
            #binding.pry
            render "new"
        end
    end

    def show
        if @user.nil? || current_user.id != @user.id
            return head(:forbidden) 
        else
            @user = User.find_by(id: params[:id])
            @new_narrative = Narrative.new(user_id: @user.id)
        end
    end

    private

    def user_params
        params.require('user').permit('name', 'email', 'password')
    end
end