class UsersController < ApplicationController
    def new
        @user = User.new
    end

    def create
        @user = User.new(user_params)
        if @user.save
            session[:user_id] = @user.id
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

    def narratives_index
        @narratives = @user.narratives
        render template: 'narratives/index'
    end

    def documents_index
        @documents = @user.documents
        render template: 'documents/index'
    end

    private

    def user_params
        params.require('user').permit('name', 'email', 'password')
    end
end