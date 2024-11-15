FactoryBot.define do
  factory :product do
    code { 'MUG' }
    name { "Reedsy #{code.capitalize}" }
    price { 600 }
  end
end
