class UsersController < ApplicationController
    before_action :find_user
    skip_before_action :find_user, only: [:new, :create]
    skip_before_action :require_login, only: [:new, :create]

    def new
        @user = User.new
    end

    def create
        binding.pry
        @user = User.new(user_params)
        if @user.save
            session[:email] = @user.email
            redirect_to user_path(@user)
        else
            #binding.pry
            render "new"
        end
    end

    def show
        #binding.pry
        if @user.nil? || current_user.id != @user.id
            #binding.pry
            return head(:forbidden) 
        else
            @user = User.find_by(id: params[:id])
            @new_narrative = Narrative.new(user_id: @user.id)
        end
    end

    #def narratives_index
    #    @prefix = "Your "
    #    @narratives = @user.narratives
    #    binding.pry
    #    render template: 'narratives/index'
    #end

    #def documents_index
    #    @documents = @user.documents
    #    render template: 'documents/index'
    #end

    private

    def user_params
        params.require('user').permit('name', 'email', 'password', 'admin')
    end

    def find_user
        @user = User.find_by(email: session[:email])
    end
end