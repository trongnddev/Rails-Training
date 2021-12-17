class ApplicationController < ActionController::Base

    #[cancancan][tranh bi dung chuong trinh khi user ko duoc phan quyen do]
    rescue_from CanCan::AccessDenied, with: :cancan_access_denied
    rescue_from ActiveRecord::RecordNotFound, with: :active_record_record_not_found
    before_action :store_user_location!, if: :storable_location?
    before_action :authenticate_user!

    def after_sign_in_path_for(resource)
        stored_location_for(resource) || root_path
    end

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

    
    
    private

        def storable_location?
        request.get? && is_navigational_format? && !devise_controller? && !request.xhr? 
        end

        def store_user_location!
        store_location_for(:user, request.fullpath)
        end
end
