class ApplicationController < ActionController::Base

    #[cancancan][tranh bi dung chuong trinh khi user ko duoc phan quyen do]
    rescue_from CanCan::AccessDenied, with: :cancan_access_denied
    rescue_from ActiveRecord::RecordNotFound, with: :active_record_record_not_found
    

    private
        def cancan_access_denied
            flash[:danger] = "You are not authorized to access this page."
            redirect_to root_url
        end
    
    private
        def active_record_record_not_found
            flash[:danger] = "Couldn't find resource."
            redirect_to root_url
        end
end
