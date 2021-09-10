class NotificationDonorToRequest < ApplicationRecord
  belongs_to :request
  belongs_to :donor
end
