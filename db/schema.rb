# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_11_14_113305) do
  create_table "discounts", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "min_product_count", null: false
    t.decimal "rate", precision: 5, scale: 4, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "min_product_count"], name: "index_discounts_on_product_id_and_min_product_count", unique: true
    t.index ["product_id"], name: "index_discounts_on_product_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "code", limit: 10, null: false
    t.string "name", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_products_on_code", unique: true
  end

  add_foreign_key "discounts", "products"
end
