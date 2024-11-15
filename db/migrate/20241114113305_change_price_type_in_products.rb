class ChangePriceTypeInProducts < ActiveRecord::Migration[7.2]
  def change
    change_column :products, :price, :integer
  end
end
