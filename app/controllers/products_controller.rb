class ProductsController < ApplicationController
  before_action :set_product, only: :update

  def index
    render json: Product.all
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: 422
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:price)
  end
end
