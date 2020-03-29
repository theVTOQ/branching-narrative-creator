class Narrative < ApplicationRecord
    belongs_to :author, class_name: User
    belongs_to :root_document, class_name: Document #for purposes of maintaining a tree of documents, have to have a root document
    has_many documents #so that every document is associated with a single narrative
end
