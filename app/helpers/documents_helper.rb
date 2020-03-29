class DocumentsHelper < ApplicationHelper
    def current_user_is_author
        user_has_access(@document.author_id)
    end
end