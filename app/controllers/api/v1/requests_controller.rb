class Api::V1::RequestsController < DashboardController
  before_action :set_api_v1_request, only: [:show, :update, :destroy]
  before_action :model_name
  before_action :check_token, only:[ :create]
  before_action :check_token2, only:[:requests_user]
  before_action :verification_token, only:[:create, :update, :destroy]
  before_action :check_token_delete_request, only:[:destroy, :update]
  # GET /api/v1/requests
  def index
    p = params[:page]
    page = (p)?(p):1
    @api_v1_requests = Request.page(page).per(10)
    render json: { requests: @api_v1_requests,page: page , per_page: 10, request_count: @api_v1_requests.count, success: true, message: "Listado com sucesso"}, status: :ok
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
    if Request.exists?(id: params[:id])
      request = ActiveRecord::Base.connection.execute("SELECT users.name, users.email, users.phone, requests.* FROM requests inner join users on requests.user_id = users.id WHERE requests.id = ?",params[:id])
      #pegar use logado params[token]
      #...
      if params[:token]
        user = User.find_by(authentication_token: params[:token])
        notifications_request = Notification.find_by(request_id: params[:id], user_id: user.id)
        notifications_request.status = "Lido"
        notifications_request.save
      end

      json_response("Pedido",true,{},request,model_name, :ok)
    else
      json_response("Pedido Não encontrado",false,[],@api_v1_request,model_name, :created)
    end
  end

  # POST /api/v1/requests
  def create
    @api_v1_request = Request.new(api_v1_request_params)
    type_r = params['type_request']
    type_r = type_r.to_i
    @api_v1_request.type_request = type_r

    if @api_v1_request.save
      json_response("Pedido efetuado",true,{},@api_v1_request,model_name, :ok)
      d = @api_v1_request.description
      u = @api_v1_request.user_id
      AlertDonorWorker.perform_async(u, @api_v1_request.id, d)
    else
      json_response("Ocorreu algum problema",false,@api_v1_request.errors.messages.values.flatten,{},model_name, :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/v1/requests/1
  def update
    if @api_v1_request.update(api_v1_request_params)
      json_response("Pedido Atualizador",true,{},@api_v1_request,model_name, :created)
    else
      json_response("Ocorreu algum problema",false,@api_v1_request.errors.messages.values.flatten,{},model_name, :unprocessable_entity)
    end
  end

  # DELETE /api/v1/requests/1
  def destroy
    if @api_v1_request != nil
      @api_v1_request.destroy
      json_response("Pedido Apagado",true,{},@api_v1_request,model_name, :ok)
    else
      json_response("Erro",false,["Falha na tentativa de apagar."],@api_v1_request,model_name, :ok)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_request
      if Request.exists?(id: params[:id])
        @api_v1_request = Request.find(params[:id])
      else
        @api_v1_request = nil
      end
    end
    
    def check_token
      token = Base64.decode64(params[:token])

      if(params[:request][:user_id])
        user_id = params[:request][:user_id]
      end

      if(User.exists?(id: user_id))
        if(User.find_by(id: user_id).authentication_token !=token || !(SessionUser.exists?(token: token)))
            breack_security
        end
      else
        breack_security
      end
    end

    def check_token2
      token = Base64.decode64(params[:token])
      if(params[:user_id])
        user_id = params[:user_id]
      end

      if(User.exists?(id: user_id))
        if(User.find_by(id: user_id).authentication_token !=token || !(SessionUser.exists?(token: token)))
            breack_security
        end
      else
        breack_security
      end
    end

    def check_token_delete_request
      begin
        token = Base64.decode64(params[:token])
        u = User.find_by(authentication_token: token)
        if(@api_v1_request != nil)
          if(u.id != @api_v1_request.user_id)
            breack_security
          end
        end
      rescue => exception
        breack_security
      end
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
