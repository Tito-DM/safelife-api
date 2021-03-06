class Api::V1::DonorsController < DashboardController

  before_action :set_api_v1_donor, only: [:show, :update_donor, :destroy]
  before_action :verification_token, only:[:create, :update_donor, :destroy]
  before_action :check_token, only: [:update_donor, :destroy]
  # GET /api/v1/donors
  def index
    p = params[:page]
    page = (p)?(p):1
    #@api_v1_donors = User.find_by_sql("SELECT donors.*, users.name, users.email, users.phone, users.type_user FROM donors INNER JOIN users ON users.id = donors.user_id").page(page).per(20)
    @api_v1_donors= User.select('donors.*, users.name, users.email, users.phone, users.type_user').joins(:donor).page(p).per(10)

    render json: { donors: @api_v1_donors,page: page , per_page: 10, user_count: @api_v1_donors.count, success: true}, status: :ok
  end

  # GET /api/v1/donors/1
  def show
    json_response("Dador",true,{},@api_v1_donor,model_name, :ok)
  end

  # POST /api/v1/donors
  def create
    
    @api_v1_donor = Donor.new(api_v1_donor_params)
    @api_v1_donor.status = 0
    if(Donor.exists?(user_id: @api_v1_donor.user_id))
      return json_response("Erro",false,["Este utilizador já é Dador"],{},model_name, :ok)
    end

    if @api_v1_donor.save
      u= User.find_by(id: @api_v1_donor.user_id)
      u.type_user = 0
      u.save
      u.authentication_token = params[:token]
      render json: {
        messages: "Dador criado.",
        is_success: true,
        error_messages: {},
        data: {User: u, Donor: @api_v1_donor}
    }, status: :ok
    else
      render json: @api_v1_donor.errors.messages.values.flatten, status: :unprocessable_entity
    end
   
  end

  # PATCH/PUT /api/v1/donors/1
  def update_donor
    donor=@donor.update(api_v1_donor_params)
    user= @api_v1_user.update(user_params)
    if ( donor && user )
          set_api_v1_donor
          json_response("Dados Atualizados com sucesso",true,{},@api_v1_donor,model_name, :created)
    else
        json_response("Ocorreu algum problema",false,@api_v1_donor.errors.messages.values.flatten,{},model_name, :ok)
    end
  end

  # DELETE /api/v1/donors/1
  def destroy
    @api_v1_donor.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_donor
      donors = Donor.select('donors.*,users.id, users.name, users.email, users.phone, users.type_user').joins(:user)
      if donors.exists?(params[:id])
        @api_v1_donor = donors.find(params[:id])
        @donor = Donor.find_by(id: params[:id])
        @api_v1_user = User.find_by(id: @api_v1_donor.user_id)
      else
        json_response("Dador não existe",false,{},{},model_name, :ok)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def api_v1_donor_params
      params.require(:donor).permit(:birthdate, :weight, :blood, :province, :gender, :user_id)
    end
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,:name, :phone, :type_user)
    end

    def check_token
      token = Base64.decode64(params[:token])
      user_id = @api_v1_user.id
      if(User.exists?(id: user_id))
        if(User.find_by(id: user_id).authentication_token !=token || !(SessionUser.exists?(token: token)))
            breack_security
        end
      else
        breack_security
      end
    end

    def model_name
      "Donor"
    end
end
