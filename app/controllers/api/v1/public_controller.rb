class Api::V1::PublicController < ApplicationController
  include Paginable

    def index_donors
        p = params[:page]
        page = (p)?(p):1
        @api_v1_donors = Donor.page(page).per(20)

        render json: { donors: @api_v1_donors,page: page , per_page: 20, user_count: @api_v1_donors.count, success: true}, status: :ok
    end

    def current_u
        render json: current_user
    end
end
