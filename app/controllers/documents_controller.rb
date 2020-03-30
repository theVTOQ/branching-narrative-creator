class DocumentsController < ApplicationController
    before_action :find_document
    skip_before_action :find_document, only: [:new, :create]
    #skip_before_action :require_login, only: [:new, :create]

    def show
        @new_parent_branch = Branch.new(child_document_id: @document.id)
        @new_child_branch = Branch.new(parent_document_id: @document.id)
    end

    def create
        @document = Document.new(document_params)
        if @document.save
            redirect_to document_path(@document)
        else
            render "new"
        end
    end

    def new
        @document = Document.new
    end

    def edit
    end

    def update
        if @document.update(document_params)
            redirect_to document_path(@document)
        else
            render "edit"
        end
    end

    def destroy
        @document.branches.delete_all
        @document.delete
        #it is conceivable that we might want to keep documents intact even if we delete one of their parent or child documents
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