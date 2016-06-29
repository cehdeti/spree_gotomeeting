Spree::Core::Engine.routes.draw do
  namespace :admin do

    resources :products

  end

# namespace :api, defaults: { format: 'json' } do
#   namespace :v1 do
#      resources :account_subscriptions, only: :show, param: :user_id
#    end
#  end

end
