FactoryBot.define do
  factory :discount do
    product
    sequence(:min_product_count) { |n| 5 * n }
    sequence(:rate) { |n| 0.02 * n }
  end
end
