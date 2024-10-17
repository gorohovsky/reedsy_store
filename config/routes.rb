Rails.application.routes.draw do
  resources :discounts
  resources :products, only: %i[index update]
end
