class DocumentsController < ApplicationController
    before_action :find_document
    skip_before_action :find_document, only: [:new, :create, :index]
    before_action :find_narrative
    skip_before_action :find_narrative, only: [:index]
    #skip_before_action :require_login, only: [:new, :create]

    def show
        if !params[:narrative_id].nil? 
            current_narrative = Narrative.find_by(id: params[:narrative_id])
            unless current_narrative.is_public || current_user = current_narrative.user
                redirect_to narratives_path, alert: "You do not have access to that narrative."
            end
            
            unless current_narrative == @document.narrative
                redirect_to narrative_path(current_narrative), alert: "That document does not belong to this narrative."
            end
        end
        
        @new_parent_branch = Branch.new
        @new_parent_document = Document.new
        @new_parent_branch.parent_document = @new_parent_document

        @new_child_branch = Branch.new
        @new_child_document = Document.new
        @new_child_branch.child_document = @new_child_document

        @new_parallel_root_doc = Document.new
    end

    def index
        @prefix = ""
        @suffix = ""
        if params[:narrative_id]
            narrative_identified = Narrative.find_by(id: params[:narrative_id])
            if narrative_identified.nil?
                #logged-in user has requested to see the documents of a narrative that doesn't exist
                deny_access
            else
                @suffix = " in #{narrative_identified.title}"
                @documents = narrative_identified.documents
                if current_user.id == narrative_identified.user.id
                    #the logged-in user is viewing the documents of own narrative
                    @prefix = "Your "
                elsif current_user.admin
                    #the logged-in user is viewing another user's narratives
                    @prefix = "#{narrative_identified.user.email}'s "
                else
                    #a logged-in non-admin user is attempting to view the documents of a narrative
                    #that this user did not create
                    deny_access
                end
            end
        elsif current_user.admin
            #the logged-in user is an admin viewing all documents, private and public
            @documents = Document.all
        else
            #the logged-in user is not admin and is attempting to view all documents
            deny_access(alert: "You do not have access to the Documents database.")
        end
    end

    def create
        @document = Document.new(document_params)
        if @document.save
            redirect_to narrative_document_path(@document.narrative, @document)
        else
            render "new"
        end
    end

    def new
        @document = Document.new
        @prefix = "Create"
    end

    def edit
        @prefix = "Update"
        @narrative =  Narrative.find_by(id: params[:narrative_id])
    end

    def update
        #binding.pry
        if @document.update(document_params)
            redirect_to narrative_document_path(@document.narrative, @document)
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
        if @document.nil?
            redirect_to "/narratives", alert:"This document doesn't exist."
        end
    end

    def find_narrative
        if !params[:narrative_id].nil?
            @narrative = Narrative.find_by(id: params[:narrative_id])
        else
            @narrative = Narrative.find_by(id: params[:document][:narrative_id])
        end
        
        if @narrative.nil?
            redirect_to "/narratives", alert:"This narrative doesn't exist."
        elsif !current_user_has_access
            redirect_to user_path(current_user), alert: "Access Denied."
        end
    end

    def current_user_is_author
        current_user.id == @narrative.user.id
    end

    helper_method :current_user_is_author

    def document_params
        params.require("document").permit("title", "passage", "branches_attributes", "narrative_id", "is_root", "child_document_attributes")
    end

    def current_user_has_access
        current_user_is_author || current_user.admin
    end

    helper_method :current_user_has_access
end