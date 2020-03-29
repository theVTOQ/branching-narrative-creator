class Document < 
    has_and_belongs_to_many :parent_documents, class_name: Document, join_table: "branches", foreign_key: "child_document_id", association_foreign_key: "parent_document_id"
    has_and_belongs_to_many :child_documents, class_name: Document, join_table: "branches", foreign_key: "parent_document_id", association_foreign_key: "child_document_id"
end
