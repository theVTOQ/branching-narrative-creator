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
        @prefix = "Public "
        @personal_viewing = false
        @private_narratives = []
        if params[:user_id]
            @personal_viewing = true
            user_identified = User.find_by(id: params[:user_id])
            if user_identified.nil?
                #logged-in user has requested to see the narratives created by
                #a user that doesn't exist
                redirect_to user_path(current_user), alert: "Access Denied"
            elsif current_user.id == params[:user_id]
                #the logged-in user is viewing own narratives
                @narratives = current_user.narratives
                @prefix = "Your "
            elsif current_user.admin
                #the logged-in user is viewing another user's narratives
                @narratives = user_identified.narratives
                @prefix = "#{user_identified.email}'s "
            end
            #binding.pry
        elsif current_user.admin
            #the logged-in user is an admin viewing all documents, private and public
            @narratives = Narrative.publicized
            @private_narratives = Narrative.privatized
        else
            #the logged-in user is not admin and is not viewing their own narratives,
            #so only show public narratives
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
            if !params[:narrative][:root_documents].nil? && @narrative.root_documents.empty?
                advisement = "Initial Root Document could not be saved. Errors: \n"
                initial_root_document = Document.new(params[:root_documents])
                initial_root_document.narrative = @narrative
                initial_root_document.save
                initial_root_document_errors = initial_root_document.errors.full_messages
                #initial_root_document.errors.full_messages.each do |msg|
                #
                #end
                for i in 0..initial_root_document_errors.length - 1
                    advisement << "#{i + 1}. #{initial_root_document_errors[i]} \n"
                end
                binding.pry
                redirect_to new_narrative_document_path(@narrative), alert: advisement
            else
                redirect_to narrative_path(@narrative)
            end
        else
            render "new"
        end
    end

    def new
        @narrative = Narrative.new
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
        if @narrative.nil?
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