class BranchesController < ApplicationController
    before_action :find_branch
    skip_before_action :find_branch, only: [:new, :create]
    def create
        @branch = Branch.create(branches_params)
        redirect_to document_path(@branch.parent_document)
    end

    def update
        if @branch.update(branches_params)
            redirect_to branch_path(@branch)
        else
            render "edit"
        end
    end

    def edit
    end

    def destroy
        @branch.delete
    end

    private

    def branches_params
        params.require("branch").permit("parent_document_id", "child_document_id")
    end

    def find_branch
        key = params[:branch_id].nil? ?  :id : :branch_id
        Branch.find_by(id: params[key])
    end
end