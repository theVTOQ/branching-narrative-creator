class Document < ApplicationRecord
    include ActiveModel::Validations
    validates :narrative_id, presence: true
    validates :title, presence: true, length: { minimum: 2, maximum: 40}
    validates_with TitleValidator

    has_and_belongs_to_many :parent_documents, class_name: Document, join_table: "branches", foreign_key: "child_document_id", association_foreign_key: "parent_document_id"
    has_and_belongs_to_many :child_documents, class_name: Document, join_table: "branches", foreign_key: "parent_document_id", association_foreign_key: "child_document_id"
    has_one :root_narrative, class_name: Narrative, optional: true #one document per narrative will act as a root document, and therefore will store the id of the narrative
    belongs_to :narrative #a narrative has_many documents; the root document also belongs to the narrative it "has"
    accepts_nested_attributes_for :branches

    def author
        self.narrative.author
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

    
end
