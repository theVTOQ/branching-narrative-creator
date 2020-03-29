class Document < 
    has_and_belongs_to_many :parent_documents, class_name: Document, join_table: "branches", foreign_key: "child_document_id", association_foreign_key: "parent_document_id"
    has_and_belongs_to_many :child_documents, class_name: Document, join_table: "branches", foreign_key: "parent_document_id", association_foreign_key: "child_document_id"
    belongs_to :narrative, optional: true
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
end
