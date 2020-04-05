class NarrativesController < ApplicationController
    before_action :find_narrative
    skip_before_action :find_narrative, only: [:new, :create, :index]
    #skip_before_action :require_login, only: [:new, :create]

    def show
        unless @narrative.is_public || @narrative.user == current_user || current_user.admin
            redirect_to narratives_path, alert: "Access Denied."
        end

        @new_root_document = Document.new(narrative_id: @narrative.id)    
        @user_can_edit = current_user_is_author
    end

    def index
        @prefix = ""
        if params[:user_id] 
            @narratives = current_user.narratives
            @prefix = "Your "
        elsif current_user.admin
            @narratives = Narrative.all
        else
            @narratives = Narrative.publicized
        end
    end

    def documents_index
        @documents = @narrative.documents
        render template: 'documents/index'
    end

    def create
        @narrative = Narrative.new(narrative_params)
        @narrative.user = current_user
        if @narrative.save
            redirect_to narrative_path(@narrative)
        else
            render "new"
        end
    end

    def new
        @narrative = Narrative.new(user_id: current_user.id)
        @prefix = "Create"
    end

    def edit
        @prefix = "Update"
    end

    def update
        if @narrative.update!(narrative_params)
            binding.pry
            redirect_to narrative_path(@narrative)
        else
            render "edit"
        end
    end

    def destroy
        @narrative.destroy
    end

    private

    def find_narrative
        @narrative = Narrative.find_by(id: params[:id])
        if @narrative.nil
           redirect_to narratives_path, alert: "That narrative does not exist." 
        end
    end

    def current_user_is_author
        current_user.id == @narrative.user.id
    end

    def narrative_params
        params.require("narrative").permit("title", "is_public", "documents_attributes")
    end
end