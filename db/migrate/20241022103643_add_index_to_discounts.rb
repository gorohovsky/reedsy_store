class AddIndexToDiscounts < ActiveRecord::Migration[7.2]
  def change
    add_index :discounts, %i[product_id min_product_count], unique: true
  end
end
