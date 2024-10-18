Rails.application.routes.draw do
  resources :products, only: %i[index update] do
    resources :discounts
  end
end
