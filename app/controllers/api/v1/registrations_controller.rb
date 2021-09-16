class Api::V1::RegistrationsController < Devise::RegistrationsController
    before_action :ensure_params_exist, only: :create
    before_action :ensure_params_exist_donor, only: :create_donor

    #skip_before_filter :verify_authenticity_token, :only => :create
    # sign up
    def create
      user = User.new user_params
      if user.save
        user.authentication_token = Base64.encode64(user.authentication_token)
        render json: {
          message: "Sign Up Successfully",
          is_success: true,
          data: {User: user},
          error_messages: []
        }, status: :ok
      else

      render json: {
        message: "Sign Up Failded",
        is_success: false,
        data: {User: user},
        error_messages: user.errors.messages.values.flatten,
      }, status: :ok
      end
    end
  
    def create_donor
        user = User.new user_params
        if user.save
            donor = Donor.new donor_params
            donor.status = 0
            donor.user_id = user.id
            if(donor.save)   
                user.authentication_token = Base64.encode64(user.authentication_token)     
                render json: {
                    messages: "Sign Up Successfully Donor",
                    is_success: true,
                    error_messages: {},
                    data: {User: user, Donor: donor}
                }, status: :ok
            else
                user.destroy
                render json: {
                    messages: "Sign Up Failded",
                    is_success: false,
                    error_messages: donor.errors.messages.values.flatten,
                    data: {}
                }, status: :ok
            end
        else
          render json: {
            messages: "Sign Up Failded",
            is_success: false,
            error_messages: user.errors.messages.values.flatten,
            data: {}
          }, status: :ok
        end
    end

    private
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,:name, :phone, :type_user)
    end
    def donor_params
        params.require(:donor).permit(:birthdate, :weight, :blood, :province, :gender)
    end
  
    def ensure_params_exist
      return if params[:user].present?
      render json: {
          messages: "Missing Params",
          is_success: false,
          data: {}
        }, status: :bad_request
    end

    def ensure_params_exist_donor
        return if params[:user].present? && params[:donor].present?
        render json: {
            messages: "Missing Params",
            is_success: false,
            data: {}
          }, status: :bad_request
    end
    
  end