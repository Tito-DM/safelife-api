class Donor < ApplicationRecord
  belongs_to :user
  has_many :answers_requests
  enum status: { disponivel: 0, indisponivel: 1 }
  #enum gender: { masculino: 0, femenino: 1 }
end
