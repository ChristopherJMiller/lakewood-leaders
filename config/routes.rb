Rails.application.routes.draw do
  resources :users, only: [:show, :new, :create, :edit, :update] do
    put '/change_password', to: 'users#change_password'
  end

  get '/verify_email/:token', to: 'users#verify_email'

  resource :sessions, only: [:create, :destroy]
  resource :tokens, only: [:create]

end
