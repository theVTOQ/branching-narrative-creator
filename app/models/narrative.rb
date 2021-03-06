class Narrative < ApplicationRecord
    include ActiveModel::Validations
    validates :user_id, presence: true
    validates :title, presence: true, length: { minimum: 2, maximum: 40}
    validates_with NarrativeTitleValidator
    before_validation :set_default_values

    scope :publicized, -> { where(is_public: true) }
    scope :privatized, -> { where(is_public: false) }
    scope :long_titles, -> { where("LENGTH(title) > 15") }

    belongs_to :user
    #belongs_to :author, class_name: "user"
    #has_one :root_document, class_name: Document #for purposes of maintaining a tree of documents, have to have a root document
    has_many :documents, dependent: :destroy #so that every document is associated with a single narrative
    accepts_nested_attributes_for :documents

    def root_documents
        self.documents.where(is_root: true)
    end

    def add_document(doc)
        self.documents << doc
    end

    def author_name
        self.user.name
    end

    #def document_attributes=(attrs)
    #    self.documents << Document.create(attrs) 
    #end

    private

    # def record_with_longest_title
    #     longest_title = nil
    #     Narrative.all.each do |narrative|

    #     end
    # end


    def set_default_values
        self.is_public ||= false
        #self.title ||= "untitled, created at: #{DateTime.current}"
    end
end
