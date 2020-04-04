module ApplicationHelper
    def current_user
        User.find_by(email: session[:email])
    end

    def logged_in
        !current_user.nil?
    end
end
