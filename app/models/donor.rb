class Donor < ApplicationRecord
  extend Enumerize
  belongs_to :user
  has_many :answers_requests
  validates :birthdate, presence: true
  validates :weight, presence: true
  validates :blood, presence: true
  validates :gender, presence: true
  enum status: { disponivel: 0, indisponivel: 1 }
end