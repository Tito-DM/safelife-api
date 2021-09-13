class Api::V1::RequestsController < ApplicationController
  before_action :set_api_v1_request, only: [:show, :update, :destroy]
  before_action :model_name
  # GET /api/v1/requests
  def index
    p = params[:page]
    page = (p)?(p):1
    @api_v1_requests = Request.page(page).per(20)
    render json: { requests: @api_v1_requests,page: page , per_page: 20, request_count: @api_v1_requests.count, success: true, message: "Listado com sucesso"}, status: :ok

  end

  # GET /api/v1/requests/:user_id
  def requests_user
    p = params[:page]
    page = (p)?(p):1
    @api_v1_requests = Request.page(page).per(10).where(["user_id = ?", params[:user_id]])
    render json: { requests: @api_v1_requests,page: page , per_page: 10, request_count: @api_v1_requests.count, success: true, message: "Listado com sucesso"}, status: :ok
  end

  # GET /api/v1/requests/1
  def show
    render json: @api_v1_request
  end

  # POST /api/v1/requests
  def create
    @api_v1_request = Request.new(api_v1_request_params)
    type_r = params['type_request']
    type_r = type_r.to_i
    @api_v1_request.type_request = type_r

    if @api_v1_request.save
      json_response("Pedido efetuado",true,{},@api_v1_request,model_name, :created)
      d = @api_v1_request.description
      u = @api_v1_request.user_id
      AlertDonorWorker.perform_async(u, @api_v1_request.id, d)
    else
      json_response("Ocorreu algum problema",false,@api_v1_request.errors,{},model_name, :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/requests/1
  def update
    if @api_v1_request.update(api_v1_request_params)
      json_response("Pedido Atualizador",true,{},@api_v1_request,model_name, :created)
    else
      json_response("Ocorreu algum problema",false,@api_v1_request.errors,{},model_name, :unprocessable_entity)
    end
  end

  # DELETE /api/v1/requests/1
  def destroy
    @api_v1_request.destroy
    json_response("Pedido Apagado",true,{},@api_v1_request,model_name, :deleted)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_request
      @api_v1_request = Request.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def api_v1_request_params
      params.require(:request).permit(:user_id, :description, :date_limit, :province)
    end

    # Only allow a trusted parameter "white list" through.
    def api_v1_notification_params
      params.require(:notification_donor_to_request).permit(:donor_id, :request_id)
    end



    def model_name
      "Request"
    end
end
