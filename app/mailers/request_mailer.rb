class RequestMailer < ApplicationMailer
    def to_user_interesting
        @user = User.find(params[:user])
        @request = Request.find(params[:request])
        @url  = 'http://savelifee.herokuapp.com/donor/profile'
        mail(
            to: @user.email,
            subject: 'Doador disponível'
          )
        Notification.create(request_id: @request.id, user_id: @donor.user_id, status: "Enviada", type: "available_donor")
    end

    def to_donor_with_same_type
        @user = User.find(params[:user])
        @request = Request.find(params[:request])
        @donor = Donor.find(params[:donor])
        @url  = "http://savelifee.herokuapp.com/request/#{@request.id}"
        mail(
            to: @user.email,
            subject: 'Pedido de Doação'
          )
        Notification.create(request_id: @request.id, user_id: @donor.user_id, status: "Enviada", type:"request_donor")
    end
end