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
    render json: @api_v1_donor
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
  def update
    if @api_v1_donor.update(api_v1_donor_params)
      render json: @api_v1_donor
    else
      render json: @api_v1_donor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/donors/1
  def destroy
    @api_v1_donor.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_donor
      @api_v1_donor = Donor.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def api_v1_donor_params
      params.require(:donor).permit(:birthdate, :weight, :blood, :province, :gender)
    end
end
