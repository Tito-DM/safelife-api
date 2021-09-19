class Api::V1::PublicController < ApplicationController

    def index_donors
        province = (params[:province])
        blood = (params[:blood])
        gender = (params[:gender])
        p = params[:page]
        page = (p)?(p):1
        @api_v1_donors = User.select('donors.*, users.name, users.email, users.phone, users.type_user').joins(:donor)
        if params[:province]
            @api_v1_donors = @api_v1_donors.where("province = ?",province )
        end 
        if params[:blood]
            @api_v1_donors = @api_v1_donors.where("blood = ?",blood )
        end
        if params[:gender]
            @api_v1_donors = @api_v1_donors.where("gender = ?",gender )
        end
        
        count = Donor.count
        @api_v1_donors = @api_v1_donors.page(p).per(10)
        
        render json: { donors: @api_v1_donors,page: page , per_page: 10, count: count, success: true}, status: :ok
    end

    def current_u
        render json: current_user
    end
end
