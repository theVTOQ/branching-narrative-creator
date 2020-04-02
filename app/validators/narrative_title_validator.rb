class NarrativeTitleValidator < ActiveModel::Validator
    def validate(record)
        if record.user.narratives.collect { |narrative| narrative.title }.include?(record.title)
            record.errors[:title] << "You've already created a narrative with this title."
        end
    end
end