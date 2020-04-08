class NarrativeTitleValidator < ActiveModel::Validator
    def validate(record)
        existing_user_narrative_with_this_title = record.user.narratives.find_by(title: record.title)
        unless existing_user_narrative_with_this_title.nil? || existing_user_narrative_with_this_title == record
            record.errors[:title] << "You've already created a narrative with this title."
        end
    end
end