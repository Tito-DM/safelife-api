class Api::V1::NotificationsController < ApplicationController
    def index
        notifications = Request.select('notifications.*').joins(:Notifications).where('notifications.user_id = ? and notifications.status = ?', params[:user_id], "Enviada").limit(10)
        render json: { notifications: notifications,page: page , per_page: 10, notifications_count: notifications.count, success: true, message: "Listado com sucesso"}, status: :ok
    end
end
