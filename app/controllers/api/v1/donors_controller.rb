class Api::V1::DonorsController < DashboardController
  include Paginable

  before_action :set_api_v1_donor, only: [:show, :update, :destroy]

  # GET /api/v1/donors
  def index
    p = params[:page]
    page = (p)?(p):1
    #@api_v1_donors = User.find_by_sql("SELECT donors.*, users.name, users.email, users.phone, users.type_user FROM donors INNER JOIN users ON users.id = donors.user_id").page(page).per(20)
    @api_v1_donors= User.select('donors.*, users.name, users.email, users.phone, users.type_user').joins(:donor).page(p).per(20)

    render json: { donors: @api_v1_donors,page: page , per_page: 20, user_count: @api_v1_donors.count, success: true}, status: :ok
  end

  # GET /api/v1/donors/1
  def show
    json_response("Pedido efetuado",true,{},@api_v1_donor,model_name, :ok)
  end

  # POST /api/v1/donors
  def create
    @api_v1_donor = Donor.new(api_v1_donor_params)

    if @api_v1_donor.save
      render json: @api_v1_donor, status: :created
    else
      render json: @api_v1_donor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/donors/1
  def update_donor
    if @api_v1_donor.update(api_v1_donor_params) && @api_v1_user.update(user_params)
          set_api_v1_donor
          json_response("Dados Atualizados com sucesso",true,{},@api_v1_donor,model_name, :created)
    else
        json_response("Ocorreu algum problema",false,@api_v1_donor.errors,{},model_name, :ok)
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
        @api_v1_user = User.find(1)
      else
        json_response("Doador não existe",false,{},{},model_name, :ok)
      end
    end

    # Only allow a trusted parameter "white list" through.
    def api_v1_donor_params
      params.require(:donor).permit(:birthdate, :weight, :blood, :province, :gender)
    end
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,:name, :phone, :type_user)
    end


    def model_name
      "Donor"
    end
end
