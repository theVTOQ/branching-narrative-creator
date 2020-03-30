class TitleValidator < ActiveModel::Validator
    def validate(record)
        if record.narrative.documents.collect { |doc| doc.title }.include?(record.title)
            record.errors[:title] << "A document in this narrative already has this title."
        end
    end
end