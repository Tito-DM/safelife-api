class DashboardController < ApplicationController
    #acts_as_token_authentication_handler_for User
    include Paginable

    public 
    def verification_token
        token = params["token"]
        if(SessionUser.find_by(token: token)==nil)
            render json: {
                message: "Tentativa de quebra de Segurança",
                is_success: true,
                error_messages: {} ,
                data: {}
              }, status: :ok
        end
    end
end