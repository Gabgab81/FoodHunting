Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  resources :restaurants do
    resources :meals, only: [ :new, :create, :edit, :update] do
      resources :ingredients, only: [ :new, :create, :edit, :update]
    end
    resources :comments, only: [:new, :create]
  end

  resources :meals, only: [:show, :destroy]
  resources :ingredients, only: [:show, :destroy]
  resources :comments, only: :destroy
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
