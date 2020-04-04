class DocumentsController < ApplicationController
    before_action :find_document
    skip_before_action :find_document, only: [:new, :create]
    #skip_before_action :require_login, only: [:new, :create]

    def show
        @new_parent_branch = Branch.new(child_document_id: @document.id)
        @new_child_branch = Branch.new(parent_document_id: @document.id)
        @user_can_edit = current_user_is_author
    end

    def index
        @prefix = ""
        if params[:user_id] 
            @documents = current_user.documents
            @prefix = "Your "
        elsif current_user.admin
            @documents = Document.all
        else
            redirect_to user_path(current_user), alert: "You do not have access to the User database."
        end
    end

    def create
        binding.pry
        @document = Document.new(document_params)
        if @document.save
            redirect_to document_path(@document)
        else
            render "new"
        end
    end

    def new
        @document = Document.new
        prefix = "Create"
    end

    def edit
        prefix = "Update"
    end

    def update
        #binding.pry
        if @document.update(document_params)
            redirect_to document_path(@document)
        else
            render "edit"
        end
    end

    def destroy
        prior_narrative = @document.narrative
        @document.child_branches.destroy_all
        @document.delete
        #it is conceivable that we might want to keep documents intact even if we delete one of their parent or child documents
        #binding.pry
        redirect_to narrative_path(prior_narrative)
    end

    private

    def find_document
        @document = Document.find_by(id: params[:id])
    end

    def current_user_is_author
        current_user.id == @document.narrative.user.id
    end

    def document_params
        params.require("document").permit("title", "passage", "branches_attributes", "narrative_id", "is_root")
    end
end