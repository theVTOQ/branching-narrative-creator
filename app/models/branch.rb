class Branch < ApplicationRecord
    belongs_to :parent_document, foreign_key: "parent_document_id", class_name: "Document"
    belongs_to :child_document, foreign_key: "child_document_id", class_name: "Document"
end
