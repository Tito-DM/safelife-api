class RequestMailer < ApplicationMailer
    def to_user_interesting
        @user = User.find(params[:user])
        @request = Request.find(params[:request])
        @url  = 'http://savelifee.herokuapp.com/donor/profile'
        mail(
            to: @user.email,
            subject: 'Doador disponível'
          )
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
        NotificationDonorToRequest.create(request_id: @request.id, donor_id: @donor.id, status: "Enviada")
    end
end