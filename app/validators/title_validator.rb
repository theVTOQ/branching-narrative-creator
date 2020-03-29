class TitleValidator < ActiveModel::Validator
    def validate(record)
        if record.narrative.documents.collect { |doc| doc.title }.include?(record.title)
            record.errors[:title] << "This title already exists for a document in this narrative."
        end
    end
end