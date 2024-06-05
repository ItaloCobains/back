class User < ApplicationRecord
  enum kind: { usuario: 0, logista: 1 }

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :cpf, presence: true, uniqueness: true, format: { with: /\A\d{11}\z/ }
  validates :full_name, presence: true
  validates :password, presence: true
  validates :kind, presence: true
end
