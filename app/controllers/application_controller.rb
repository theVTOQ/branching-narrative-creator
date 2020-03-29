class ApplicationController < ActionController::Base
    before_action :require_login

    private
    
    def current_user
        User.find_by(name: session[:name])
    end

    def logged_in
        !session[:name].nil?
    end

    def user_has_access(user_id)
        current_user.id == user_id
    end

    def require_login
        unless logged_in
            flash[:error] = "You must be logged in to access this feature."
            redirect_to "/signin"
        end
    end
end
