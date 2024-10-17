class Discount < ApplicationRecord
  belongs_to :product

  validates :min_product_count, numericality: { greater_than: 0, message: 'Must be a number greater than 0' }
  validates :rate, numericality: { in: 0.0001...1, message: 'Must be a number in the range of 0.0001 to 0.9999' }
end
