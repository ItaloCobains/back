class Transaction < ApplicationRecord
  belongs_to :user

  enum kind: { deposit: 0, withdraw: 1 }

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :kind, presence: true, inclusion: { in: kinds.keys }
  validates :user, presence: true
end
