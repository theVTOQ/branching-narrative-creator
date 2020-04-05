class Document < ApplicationRecord
    include ActiveModel::Validations
    validates :narrative_id, presence: true
    validates :title, presence: true, length: { minimum: 2, maximum: 50}
    validates_with DocumentTitleValidator
    before_validation :set_default_values

    #has_and_belongs_to_many :parent_documents, class_name: "document", join_table: "branches", foreign_key: "parent_document_id", association_foreign_key: "child_document_id"
    #has_and_belongs_to_many :child_documents, class_name: "document", join_table: "branches", foreign_key: "child_document_id", association_foreign_key: "parent_document_id"
    
    has_many :parent_branches, foreign_key: "child_document_id", class_name: "Branch"
    has_many :parent_documents, through: :parent_branches, source: :parent_document #class_name: "Document"
    has_many :child_branches, foreign_key: "parent_document_id", class_name: "Branch"
    has_many :child_documents, through: :child_branches, source: :child_document #class_name: "Document"

    #belongs_to :root_narrative, class_name: "narrative" one document per narrative will act as a root document, and therefore will store the id of the narrative
    belongs_to :narrative #a narrative has_many documents; the root document also belongs to the narrative it "has"
    
    #accepts_nested_attributes_for :branches
    #accepts_nested_attributes_for :parent_branches

    def author
        self.narrative.user
    end

    def author_name
        self.author.name
    end

    def author_id
        self.author.id
    end

    def self.eligible_parent_documents(document)
        self.all.where(narrative_id: document.narrative.id).where.not(child_document_ids: document.child_document_ids)
        #direct child documents of this document are not eligible to also be direct parents of this document
    end

    private

    def set_default_values
        self.is_root ||= false
    end

    def branches_attributes=(branch_attrs)
        binding.pry
        branch = Branch.create(branch_attrs)
        #if branch.save

        #else

        #end
    end
    
end
