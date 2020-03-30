class NarrativesController < ApplicationController
    before_action :find_narrative
    skip_before_action :find_narrative, only: [:new, :create]
    #skip_before_action :require_login, only: [:new, :create]

    def show
        @new_root_document = Document.new(narrative_id: self.id)    
    end

    def create
        @narrative = Narrative.new(narrative_params)
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
        if @document.update(document_params)
            redirect_to document_path(@document)
        else
            render "edit"
        end
    end

    def destroy
        @document.destroy
    end

    private

    def find_document
        #key = ? :

        @document = Document.find_by(id: params[:document_id])
    end

    def document_params
        params.require("document").permit("title", "passage", "branches_attributes")
    end
end