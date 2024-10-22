class CartController < ApplicationController
  include ParamValidators::Cart

  before_action :validate_params

  def check_price
    render json: CartCalculationService.new(@valid_params).execute
  end

  private

  def cart_params
    params.require(:products)
  end

  def validate_params
    @valid_params = PriceCheckValidator.new(cart_params).validate!
  rescue Errors::ParamsInvalid
    render json: { error: "The 'products' param contains invalid values" }, status: 400
  end
end
