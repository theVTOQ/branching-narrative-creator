class BranchesController < ApplicationController
    def create
        @branch = Branch.create(branches_params)
        redirect_to document_path(@branch.parent_document)
    end

    def update
    end

    def edit
    end

    def destroy
    end

    private

    def branches_params
        params.require("branch").permit("parent_document_id", "child_document_id")
    end
end