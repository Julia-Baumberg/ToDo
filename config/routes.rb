Rails.application.routes.draw do
  resources :users

  root 'home#index'

  get 'home' => 'home#index', as: :home

  get "up" => "rails/health#show", as: :rails_health_check

  get 'signup' => 'users#new'
  get 'signin' => 'sessions#new'
  resource :session, only: %i[new create destroy]

  get 'all_tasks' => 'tasks#all_tasks'
  resources :tasks do
    member do
      patch :mark_completed
    end
    resources :comments, only: [:index, :new, :create, :edit, :update, :destroy]

  end
end
