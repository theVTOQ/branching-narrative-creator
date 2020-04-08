class ApplicationController < ActionController::Base
    before_action :require_login
    helper_method :logged_in

    private
    
    def current_user
        User.find_by(email: session[:email])
    end
    
    helper_method :current_user

    def logged_in
        !current_user.nil?
    end

    helper_method :logged_in


    def require_login
        unless logged_in
            flash[:error] = "You must be logged in to access this feature."
            redirect_to "/signin"
        end
    end

    def deny_access(path: user_path(current_user), alert: "Access Denied")
        redirect_to path, alert: alert
    end

    #def form_submit_message_prefix(is_new)
    #    is_new ? "Create" : "Update"
    #end
end
