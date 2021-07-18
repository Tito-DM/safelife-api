class Api::V1::AnswersRequestsController < ApplicationController
  before_action :set_api_v1_answers_request, only: [:show, :update, :destroy]
  before_action :model_name

  # GET /api/v1/answers_requests
  def index

    p = params[:page]
    page = (p)?(p):1
    @api_v1_answers_requests = Donor.page(page).per(20)

    render json: { answers_requests: @api_v1_answers_requests,page: page , per_page: 20, answer_request_count: @api_v1_answers_requests.count, success: true}, status: :ok

  end

  # GET /api/v1/answers_requests/1
  def show
    render json: @api_v1_answers_request
  end

  # POST /api/v1/answers_requests
  def create
    @api_v1_answers_request = AnswersRequest.new(api_v1_answers_request_params)

    if @api_v1_answers_request.save
      json_response("Sua resposta foi registada",true,{},@api_v1_answers_request,model_name, :created)
    else
      json_response("Ocorreu algum problema",false,@api_v1_answers_request.errors,{},model_name, :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/answers_requests/1
  def update
    if @api_v1_answers_request.update(api_v1_answers_request_params)
      json_response("Resposta Atualizada",true,{},@api_v1_answers_request,model_name, :created)
    else
      json_response("Ocorreu algum problema",false,@api_v1_answers_request.errors,{},model_name, :unprocessable_entity)
    end
  end

  # DELETE /api/v1/answers_requests/1
  def destroy
    @api_v1_answers_request.destroy
    json_response("Resposta Apagada",true,{},@api_v1_answers_request,model_name, :deleted)

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_answers_request
      @api_v1_answers_request = AnswersRequest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def api_v1_answers_request_params
      params.require(:answers_request).permit(:request_id, :donor_id)
    end
    
    def model_name
      "Answers_request"
    end
end
