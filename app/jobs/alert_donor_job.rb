class AlertDonorJob < ApplicationJob
  queue_as :default

  def perform(user, request)
   
  end
end
