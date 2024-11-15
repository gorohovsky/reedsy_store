class ProductSet
  delegate :code, :price, to: :@product

  attr_reader :product_count

  def initialize(product, product_count)
    @product = product
    @product_count = product_count
  end

  def discounted_price
    @product_count * price * price_coefficient
  end

  def price_coefficient = 1 - discount_rate

  def discount_rate = discount&.rate.to_d

  def discount
    @product
      .discounts
      .sort_by { |d| -d.min_product_count }
      .detect { |d| d.min_product_count <= @product_count }
  end
end
