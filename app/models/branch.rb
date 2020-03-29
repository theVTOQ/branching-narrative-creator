class Branch < ApplicationRecord
    belongs_to :parent_document, class_name: Document
    belongs_to :child_document, class_name: Document
end
