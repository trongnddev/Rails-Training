class NotificationsController < ApplicationController
  before_action :set_notification, only: %i[ show edit update destroy ]

  # GET /notifications or /notifications.json
  def index
    @notifications = Notification.where(user_id: current_user.id)
  end

  # GET /notifications/1 or /notifications/1.json
  def show
    Notification.update_seen(@notification.id)
  end

  # DELETE /notifications/1 or /notifications/1.json
  def destroy
    @notification.destroy
    respond_to do |format|
      format.html { redirect_to notifications_url, notice: "Notification was successfully destroyed." }
      format.json { head :no_content }
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
