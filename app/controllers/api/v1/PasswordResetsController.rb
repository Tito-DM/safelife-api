class Api::V1::PasswordResetsController < DashboardController
    def new; end
    def edit_pass
      # finds user with a valid token
      begin
        token = Base64.decode64(params[:token])
        token_decripted = Devise.token_generator.digest(User,:reset_password_token, token)
        @user = User.find_by!(reset_password_token: token_decripted)
        rescue ActiveSupport::MessageVerifier::InvalidSignature
          json_response("O token está expirado, tente novamente.",false,{},@user,"Utilizador", :ok)
      rescue => exception
        breack_security
      end
      
    end
        
    def forgot_password
      user = User.find_by_email(params[:email])
      if user.present?
          user.send_reset_password_instructions
          json_response("Foi enviado um email de recuperação para #{params[:email]}",true,{},user,"User", :created)
      else
          json_response("O email #{params[:email]} não exite.",false,{},user,"Utilizador", :created)
      end
    end

    def update_pass
        # updates user's password
        begin
          token = Base64.decode64(params[:token])
          token_decripted = Devise.token_generator.digest(User,:reset_password_token, token)
          @user = User.find_by(reset_password_token: token_decripted)
          if @user.present?
            if @user.update(password_params)
                json_response("Palavra-passe alterada com sucesso.",true,{},@user,"Utilizador", :ok)
            else
              json_response("Ocorreu um erro ao atualizar a Palavra-passe",false,{},@user,"Utilizador", :ok)
            end
          else
            json_response("Token Inválido.",false,{},@user,"Utilizador", :ok)
          end
        rescue => exception
          breack_security
        end
        
    end
    private
    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end
  end