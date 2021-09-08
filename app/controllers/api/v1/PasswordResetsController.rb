class Api::V1::PasswordResetsController < DashboardController
    def new; end
    def edit
      # finds user with a valid token
      @user = User.find_signed!(params[:token], purpose: 'password_reset')
      rescue ActiveSupport::MessageVerifier::InvalidSignature
        json_response("O token está expirado, tente novamente.",false,{},@user,"Utilizador", :ok)
    end
        
    def forgot_password
      user = User.find_by_email(params[:email])
      if user.present?
          user.send_reset_password_instructions
          json_response("Foi enviado um email de recuperação para #{params[:email]}",true,{},user,"Utilizador", :created)
      else
          json_response("O email #{params[:email]} não exite.",false,{},user,"Utilizador", :created)
      end
    end

    def update
        # updates user's password
        @user = User.find_signed!(params[:token], purpose: 'password_reset')
        if @user.update(password_params)
            json_response("Palavra-passe alterada com sucesso.",true,{},@user,"Utilizador", :ok)
        else
            render :edit
        end
    end
    private
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end