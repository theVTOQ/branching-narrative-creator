class DocumentsController < ApplicationController
    before_action :find_document
    skip_before_action :find_document, only: [:new, :create]
    skip_before_action :require_login, only: [:new, :create]

    def show
    end

    def create
        if Document.create(document_params)
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
        @document.destroy
    end

    private

    def find_document
        #key = ? :

        @document = Document.find_by(id: params[:document_id])
    end

    def document_params
        params.require("document").permit("title", "passage")
    end
end