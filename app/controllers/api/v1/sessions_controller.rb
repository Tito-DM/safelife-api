class Api::V1::SessionsController < DashboardController
    before_action :sign_in_params, only: :create
    before_action :load_user, only: :create
    before_action :verification_token, only: :destroy
    # sign in
    def create
      if(@user)
        if @user.valid_password?(sign_in_params[:password])
          #sign_in "user", @user
          if !SessionUser.exists?(token: @user.authentication_token)
            SessionUser.create(token: @user.authentication_token)
          end
          @user.authentication_token = Base64.encode64(@user.authentication_token)
          if Donor.exists?(user_id: @user.id)
            donor= Donor.find_by(user_id: @user.id)
            render json: {
              message: "Login efetuado com sucesso",
              is_success: true,
              error_messages: {} ,
              data: {User: @user, Donor: donor}
            }, status: :ok
          else
            render json: {
              message: "Login efetuado com sucesso",
              is_success: true,
              error_messages: {} ,
              data: {User: @user}
            }, status: :ok
          end
        else
          render json: {
            messages: "Ocorreu algum problema",
            is_success: false,
            error_messages: ["Credênciais erradas"],
            data: {User: {}}
          }, status: :ok
        end
      else
        render json: {
          messages: "Ocorreu algum problema",
          is_success: false,
          error_messages: ["Credênciais erradas"],
          data: {User: {}}
        }, status: :ok
      end
    end

    def destroy
      token = Base64.decode64(params["token"])
      if SessionUser.exists?(token: token)
        s = SessionUser.find_by(token: token)
        if s.destroy
          render json: {
            messages: "Sessão terminada",
            is_success: true,
            error_messages: [""],
            data: {User: {}}
          }, status: :ok
        end
      else
        breack_security
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