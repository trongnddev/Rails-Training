class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[show edit update destroy]
  before_action :authenticate_user!


  #authorization with cancancan
  load_and_authorize_resource

  # GET /notifications or /notifications.json
  def index
    @notifications = Notification.where("user_id = #{current_user.id} AND message != 'for staff'").paginate(:page => params[:page], :per_page => 10).order("created_at DESC, seen")
  end

  # GET /notifications/1 or /notifications/1.json
  def show
    if @notification.seen == false
      Notification.update_seen(@notification.id)
    end
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_notification
      @notification = Notification.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def notification_params
      params.require(:notification).permit(:message, :seen, :user_id)
    end
end
