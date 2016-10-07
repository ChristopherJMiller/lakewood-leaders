Rails.application.routes.draw do
  root 'pages#home'

  resources :users, only: [:index, :show, :new, :create, :edit, :update] do
    patch '/change_password', to: 'users#change_password'
    resources :messages, except: [:edit, :update]
  end

  resources :events do
    resources :participants, only: [:index, :create, :destroy]
  end

  get '/verify_email/:token', to: 'users#verify_email'
  get '/verify_parent_email/:token', to: 'users#verify_parent_email'

  resource :sessions, only: [:create, :destroy]
  resource :tokens, only: [:create]

  namespace :admin do
    get 'dashboard'
    get 'users'
    get 'events'
  end

  resources :announcements

  get 'log_in', to: 'sessions#new'
  get 'register', to: 'users#new'
  get 'log_out', to: 'sessions#destroy'
end
