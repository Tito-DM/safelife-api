class User < ApplicationRecord
  include ActiveModel::Validations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  acts_as_token_authenticatable
  has_many :requests
  validates :password, confirmation: true
  validates :name, presence: true, exclusion: { in: %w(admin superuser) }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  #enum type_user: { pessoa: 0, instituicao:1 }
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
