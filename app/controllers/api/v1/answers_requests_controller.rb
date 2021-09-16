class Api::V1::AnswersRequestsController < DashboardController
  before_action :set_api_v1_answers_request, only: [:show, :update, :destroy]
  before_action :model_name
  before_action :check_token, only:[:answers_request]
  before_action :check_token_create, only: :create

  # GET /api/v1/answers_requests
  def index
    p = params[:page]
    page = (p)?(p):1
    @api_v1_answers_requests = Donor.page(page).per(10)
    render json: { answers_requests: @api_v1_answers_requests,page: page , per_page: 10, answer_request_count: @api_v1_answers_requests.count, success: true}, status: :ok
  end

  # GET /api/v1/answers_requests/:request_id
  def answers_request
    p = params[:page]
    page = (p)?(p):1
    @api_v1_answers_request = ActiveRecord::Base.connection.execute("SELECT donors.*, users.name, users.email, users.phone, requests.* FROM answers_requests inner join donors on answers_requests.donor_id = donors.id inner join requests on answers_requests.request_id = requests.id inner join users on donors.user_id = users.id WHERE requests.id = #{params['request_id']}")
    render json: { answers_requests: @api_v1_answers_request,page: page , per_page: 10, request_count: @api_v1_answers_request.count, success: true, message: "Listado"}, status: :ok
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
      donor= @api_v1_answers_request.donor_id
      user =  @api_v1_answers_request.donor.user_id
      request = @api_v1_answers_request.request_id
      RequestMailer.with(user: user, request: request).to_user_interesting.deliver_now
    else
      json_response("Ocorreu algum problema",false,@api_v1_answers_request.errors.messages.values.flatten,{},model_name, :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/answers_requests/1
  def update
    if @api_v1_answers_request.update(api_v1_answers_request_params)
      json_response("Resposta Atualizada",true,{},@api_v1_answers_request,model_name, :created)
    else
      json_response("Ocorreu algum problema",false,@api_v1_answers_request.errors.messages.values.flatten,{},model_name, :unprocessable_entity)
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

    def check_token
      begin
        token = Base64.decode64(params[:token])
        if(Request.exists?(id: params[:request_id]))
          user_id = Request.find_by(id: params[:request_id]).user_id
          if(User.find_by(id: user_id).authentication_token != token || !(SessionUser.exists?(token: token)))
              breack_security
          end
        end
      rescue => exception
        breack_security
      end
    end

    def check_token_create
      begin
        token = Base64.decode64(params[:token])
        if(Request.exists?(id: params[:answers_request][:request_id]) && Donor.exists?(id: params[:answers_request][:donor_id]) )
          user_id = Donor.find_by(id: params[:answers_request][:donor_id]).user_id
          if(User.find_by(id: user_id).authentication_token != token || !(SessionUser.exists?(token: token)))
              breack_security
          end
        end
      rescue => exception
        breack_security
      end
    end


    # Only allow a trusted parameter "white list" through.
    def api_v1_answers_request_params
      params.require(:answers_request).permit(:request_id, :donor_id)
    end
    
    def model_name
      "Answers_request"
    end
end
