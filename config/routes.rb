Rails.application.routes.draw do
  get 'locations/show'
  namespace :api do 
    namespace :v1 do 
      namespace :users do 
        post 'sessions', to: 'sessions#create'
        post 'registrations', to: 'registrations#create'
      end

      get 'locations', to: 'locations#show'
    end
  end
end
