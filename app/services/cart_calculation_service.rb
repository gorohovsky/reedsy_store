class CartCalculationService
  def initialize(cart_params)
    @cart_params = cart_params
  end

  def execute
    processed_products = {}
    total = 0

    product_sets.each do |set|
      processed_products[set.code] = set.product_count
      total += set.discounted_price
    end

    { products: processed_products, total: total }
  end

  private

  def product_sets
    products.map { ProductSet.new(_1, @cart_params[_1.code]) }
  end

  def products
    Product.where(code: @cart_params.keys).eager_load(:discounts)
  end
end
