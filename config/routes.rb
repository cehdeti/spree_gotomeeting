

Spree::Core::Engine.add_routes do
  namespace :api do
    namespace :v1 do
      match 'webinars/all' => 'webinars#all', :via => :get

      resources :webinars

      resources :webinar_registrations

      resources :users do
        get 'webinar_registrations'
      end

    end
  end
end