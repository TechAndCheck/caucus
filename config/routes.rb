Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "home#index"

  get "/winnow", to: "winnow#index", as: :winnow_index
  patch "/winnow", to: "winnow#submit", as: :winnow_submit

  namespace :admin do
    # Add dashboard for your models here
    resources :categories
    resources :claims
    resources :users
    resources :roles, only: [:index, :show]

    root to: "categories#index" # <--- Root route
  end
end
