class DiscountsController < ApplicationController
  before_action :set_discount, only: %i[show update destroy]

  def index
    render json: Discount.all
  end

  def show
    render json: @discount
  end

  def create
    @discount = Discount.new(discount_params)

    if @discount.save
      render json: @discount, status: :created, location: @discount
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

  def set_discount
    @discount = Discount.find(params[:id])
  end

  def discount_params
    params.require(:discount).permit(:product_id, :min_product_count, :rate)
  end
end
