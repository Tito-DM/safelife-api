class Donor < ApplicationRecord
  belongs_to :user
  has_many :answers_requests
  validates :birthdate, presence: true
  validates :weight, presence: true
  validates :blood, presence: true
  enum status: { disponivel: 0, indisponivel: 1 }
  enum gender: { masculino: 0, femenino: 1 }
end