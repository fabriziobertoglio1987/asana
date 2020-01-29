Rails.application.routes.draw do
  namespace :users do 
    post 'sessions', to: 'sessions#create'
    post 'registrations', to: 'registrations#create'
  end
end
