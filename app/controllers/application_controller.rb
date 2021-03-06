class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :user_signed_in?
  include UrlHelper

  private  
    def current_user  
      @current_user ||= User.find_by_id(session[:user_id]) if session[:user_id]  
    end
    
    def user_signed_in?
      return 1 if current_user 
    end
      
    def authenticate_user!
      if !current_user
        flash[:error] = 'You need to sign in before accessing this page!'
        redirect_to signin_services_path
      end
    end

    def admin_only!
      unless user_signed_in? && current_user.admin?
        flash[:error] = 'You don\'t have admin access!'
        redirect_to dashboard_path
        
      end
    end
end
