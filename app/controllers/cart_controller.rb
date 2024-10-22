class CartController < ApplicationController
  before_action :validate_params

  def check_price
    if @valid_params.blank?
      render_products_param_error
    else
      render json: CartCalculationService.new(@valid_params).execute
    end
  end

  private

  def cart_params
    @cart_params ||= params.require(:products)
  end

  def validate_params
    return render_products_param_error unless cart_params.is_a? ActionController::Parameters

    @valid_params = cart_params
      .to_unsafe_h
      .filter_map do |product_code, product_count|
        next unless (count = product_count.to_s.to_i).positive?

        [product_code.upcase, count]
    end.to_h
  end

  def render_products_param_error
    render json: { error: "The 'products' param contains invalid values" }, status: 400
  end
end
