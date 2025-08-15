Rails.application.routes.draw do
  resources :users
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  resource :session, only: %i[new create destroy]
  get 'all_tasks' => 'tasks#all_tasks'
  resources :tasks do
    member do
      patch :mark_completed
    end
    resources :comments, only: [:new, :create, :destroy]

  end
end
