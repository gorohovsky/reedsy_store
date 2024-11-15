class Product < ApplicationRecord
  has_many :discounts, dependent: :destroy

  validates :code, format: { with: /\A[A-Z]+\z/, message: 'allows only uppercase letters' }
  validates :code, length: { within: 2..10 }
  validates :name, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0, message: 'Must be an integer greater than 0' }
end
