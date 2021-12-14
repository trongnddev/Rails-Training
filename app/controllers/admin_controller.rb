class AdminController < ApplicationController
    layout "admin/layouts/admin"
    before_action :check_staff

    def check_staff
        user ||= current_user
        
          if user.role == "user" || !user.role.present?
            redirect_to root_path
            flash[:danger] = "Couldn't find resource."
          end
        
      end
    
end