Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "winnow#index"
  patch "/", to: "winnow#submit", as: :winnow_submit

  namespace :admin do
    # Add dashboard for your models here
    resources :categories
    resources :claims

    root to: "categories#index" # <--- Root route
  end
end
