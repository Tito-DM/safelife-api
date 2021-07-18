class Api::V1::SessionsController < Devise::SessionsController
    before_action :sign_in_params, only: :create
    before_action :load_user, only: :create
    # sign in
    def create
      if(@user)
        if @user.valid_password?(sign_in_params[:password])
          sign_in "user", @user
          render json: {
            message: "Login efetuado com sucesso",
            is_success: true,
            error_messages: {} ,
            data: {User: @user}
          }, status: :ok
        else
          render json: {
            message: "Ocorreu algum problema",
            is_success: false,
            error_messages: {password: "Palavra-passe errada"} ,
            data: {User: {}}
          }, status: :unauthorized
        end
      else
        render json: {
          messages: "Ocorreu algum problema",
          is_success: false,
          error_messages: {notfound:"Utilizador não encontrado"},
          data: {User: {}}
        }, status: :unauthorized
      end
    end
  
    private

    def sign_in_params
      params.require(:sign_in).permit :email, :password
    end
  
    def load_user
      if(User.find_by(email: sign_in_params[:email]))
        @user = User.find_for_database_authentication(email: sign_in_params[:email])
        if @user
          return @user
        else
          render json: {
            messages: "Cannot get User",
            is_success: false,
            data: {}
          }, status: :failure
        end
      else
       @user = nil
      end
    end
  end