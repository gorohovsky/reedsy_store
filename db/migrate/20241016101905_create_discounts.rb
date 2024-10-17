class CreateDiscounts < ActiveRecord::Migration[7.2]
  def change
    create_table :discounts do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :min_product_count, null: false
      t.decimal :rate, precision: 5, scale: 4, null: false

      t.timestamps
    end
  end
end
