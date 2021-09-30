class Api::V1::NotificationsController < ApplicationController
    def index
        #notifications = Request.select('notifications.*').joins(:Notifications).where('notifications.user_id = ? and notifications.status = ?', params[:user_id], "Enviada").limit(10)
        notifications = Notification.limit(10).find_by(user_id: params[:user_id], status:"Enviada")
        notifications = (notifications)?(notifications):([])
        render json: { notifications: notifications,page: 1 , per_page: 10, notifications_count: 0, success: true, message: "Listado com sucesso"}, status: :ok
    end
end
