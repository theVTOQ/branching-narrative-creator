class Narrative < ApplicationRecord
    belongs_to :author, class_name: User
    has_one :document
end
