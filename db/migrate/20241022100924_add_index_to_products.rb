class AddIndexToProducts < ActiveRecord::Migration[7.2]
  def change
    add_index :products, :code, unique: true
  end
end
