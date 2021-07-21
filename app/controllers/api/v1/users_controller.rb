class Api::V1::UsersController < DashboardController
    include Paginable

    before_action :set_api_v1_user, only: [:show, :update, :destroy]

    def show
        json_response("Pedido efetuado",true,{},@api_v1_user,model_name, :ok)
    end

    def update
        @api_v1_user.authentication_token=params[:token]
        if @api_v1_user.update(user_params)
            json_response("Dados Atualizados com sucesso",true,{},@api_v1_user,model_name, :created)
        else
            json_response("Ocorreu algum problema",false,@api_v1_user.errors,{},model_name, :ok)
        end
    end
    
    private
    def set_api_v1_user
        if User.exists?(params[:id])
            @api_v1_user = User.find(params[:id])
        else
            json_response("Utilizador não existe",false,{},{},model_name, :ok)
        end
    end
  
      # Only allow a trusted parameter "white list" through.
      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation,:name, :phone, :type_user)
      end
  
  
      def model_name
        "Utilizador"
      end
end