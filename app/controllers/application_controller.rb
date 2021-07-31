class ApplicationController < ActionController::API
    #acts_as_token_authentication_handler_for User

    protected
    def json_response(msg,success, error_message, data, model,status)
        render json: {
            message: msg,
            is_success: success,
            error_messages: error_message,
            data: {"#{model}": data}
        }, status: status
    end
    
end
