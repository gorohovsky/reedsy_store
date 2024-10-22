Rails.application.routes.draw do
  resources :products, only: %i[index update] do
    resources :discounts
  end

  get 'check_price', to: 'cart#check_price', defaults: { format: :json }
end
