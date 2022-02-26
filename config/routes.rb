Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :geolocations, only: %i[show create destroy]
    end
  end
end
