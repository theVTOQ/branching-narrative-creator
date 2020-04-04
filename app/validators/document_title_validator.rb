class DocumentTitleValidator < ActiveModel::Validator
    def validate(record)
        binding.pry
        existing_narrative_document_with_this_title = record.narrative.documents.find_by(title: record.title)
        unless existing_narrative_document_with_this_title.nil? || existing_narrative_document_with_this_title == record
            #binding.pry
            record.errors[:title] << "You've already created a document with this title in this narrative."
        end
    end
end