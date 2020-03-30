class Narrative < ApplicationRecord
    belongs_to :author, class_name: "user"
    #has_one :root_document, class_name: Document #for purposes of maintaining a tree of documents, have to have a root document
    has_many :documents #so that every document is associated with a single narrative

    def root_documents
        self.documents.where(is_root: true)
    end

    def add_document(doc)
        self.documents << doc
    end
end
