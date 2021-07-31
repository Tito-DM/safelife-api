class Request < ApplicationRecord
  belongs_to :user
  has_many :answers_requests
  validates :type_request, presence: true
  validates :description, presence: true
  validates :province, presence: true
  validates :user_id, presence: true

  enum type_request: { blood: 0, organs: 1 }
end
