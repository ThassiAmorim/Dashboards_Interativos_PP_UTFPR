Rails.application.routes.draw do
  get 'chart/index'
  get 'home', to: 'home#index'
  get 'dashboard', to: 'work_packages#dashboard'
  get 'relatorio', to: 'work_packages#relatorio'
  get 'search', to: 'work_packages#search'
  get 'chart/index'

  resources :work_packages

  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
