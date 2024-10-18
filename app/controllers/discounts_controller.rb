class DiscountsController < ApplicationController
  before_action :set_product
  before_action :set_discount, only: %i[show update destroy]

  def index
    render json: @product.discounts
  end

  def show
    render json: @discount
  end

  def create
    @discount = @product.discounts.new(discount_params)

    if @discount.save
      render json: @discount, status: :created, location: product_discount_url(@product, @discount)
    else
      render json: @discount.errors, status: :unprocessable_entity
    end
  end

  def update
    if @discount.update(discount_params)
      render json: @discount
    else
      render json: @discount.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @discount.destroy!
  end

  private

  def set_product
    @product = Product.find params[:product_id]
  end

  def set_discount
    @discount = @product.discounts.find params[:id]
  end

  def discount_params
    params.require(:discount).permit(:min_product_count, :rate)
  end
end
