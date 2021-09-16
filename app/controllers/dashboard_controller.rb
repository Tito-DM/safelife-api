class DashboardController < ApplicationController
    #acts_as_token_authentication_handler_for User
    include Paginable

    public 
    def verification_token
        begin
            token = Base64.decode64(params[:token])
            if(!SessionUser.exists?(token: token))
                breack_security
            end
        rescue => exception
            breack_security
        end
        
    end

    def breack_security
            render json: {
                message: "Tentativa de quebra de Segurança",
                is_success: false,
                error_messages: {} ,
                data: {}
            }, status: :ok
    end
end