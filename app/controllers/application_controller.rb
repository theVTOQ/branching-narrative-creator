class ApplicationController < ActionController::Base
    def current_user
        User.find_by(name: session[:name])
    end
end
