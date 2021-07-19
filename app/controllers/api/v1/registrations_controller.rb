class Api::V1::RegistrationsController < Devise::RegistrationsController
    before_action :ensure_params_exist, only: :create
    before_action :ensure_params_exist_donor, only: :create_donor

    #skip_before_filter :verify_authenticity_token, :only => :create
    # sign up
    def create
      user = User.new user_params
      if user.save
        if(user.type_user == 0)
          
        else

        end
        render json: {
          message: "Sign Up Successfully",
          is_success: true,
          data: {user: user},
          error_message: {}
        }, status: :ok
      else

        render json: {
          message: "Sign Up Failded",
          is_success: false,
          data: {user: user},
          error_message: user.errors.messages,
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
                render json: {
                    message: "Sign Up Successfully Donor",
                    is_success: true,
                    error_message: {},
                    data: {user: user, donor: donor}
                }, status: :ok
            else
                user.destroy
                render json: {
                    message: "Sign Up Failded",
                    is_success: false,
                    error_message: donor.errors.messages,
                    data: {}
                }, status: :ok
            end
        else
          render json: {
            message: "Sign Up Failded",
            is_success: false,
            error_message: user.errors.messages,
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
  
    def s r
      return if params[:user].present?
      render json: {
          message: "Missing Params",
          is_success: false,
          data: {}
        }, status: :bad_request
    end

    def ensure_params_exist_donor
        return if params[:user].present? && params[:donor].present?
        render json: {
            message: "Missing Params",
            is_success: false,
            data: {}
          }, status: :bad_request
    end
    
  end