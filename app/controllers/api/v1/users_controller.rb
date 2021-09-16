class Api::V1::UsersController < DashboardController
    before_action :set_api_v1_user, only: [:show, :update, :destroy]
    before_action :check_token, only:[:update]

    def show
        json_response("Utilizador",true,{},@api_v1_user,model_name, :ok)
    end

    def update
        if @api_v1_user.update(user_params)
            json_response("Dados Atualizados com sucesso",true,{},@api_v1_user,model_name, :created)
        else
            json_response("Ocorreu algum problema",false,@api_v1_user.errors.messages.values.flatten,{},model_name, :ok)
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

    def check_token
        token = Base64.decode64(params[:token])

        if (@api_v1_user.authentication_token != token || !(SessionUser.exists?(token: token)))
            json_response("Tentativa de Quebra de Segurança",false,[],{},model_name, :ok)
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