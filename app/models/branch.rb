class Branch < ApplicationRecord
    belongs_to :parent_document, foreign_key: "parent_document_id", class_name: "Document"
    belongs_to :child_document, foreign_key: "child_document_id", class_name: "Document"

    def child_document_attributes=(attrs)
        self.child_document = Document.find_or_create_by(attrs)
    end

    def parent_document_attributes=(attrs)
        self.parent_document = Document.find_or_create_by(attrs)
    end

    def narrative
        self.parent_document.narrative
    end
end
