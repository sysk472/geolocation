Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api, constraints: { format: 'json' } do
    namespace :v1 do
      resources :geolocations, only: %i[show create destroy]
      get '/geolocations', to: 'geolocations#show_by_query'
    end
  end

  get "/404" => "errors#not_found"
  get "/500" => "errors#exception"
end
