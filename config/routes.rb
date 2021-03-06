Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "home#index"

  get "/instructions", to: "home#instructions", as: :instructions

  get "/winnow", to: "winnow#index", as: :winnow_index
  patch "/winnow", to: "winnow#submit", as: :winnow_submit

  # We set users to user here for prettier and more make-sensy paths
  resources :users, path: "user", only: [:index, :edit, :update], as: :user

  namespace :admin do
    # Add dashboard for your models here
    resources :categories

    get "/claims/export", to: "claims#export", as: :claim_export
    get "/claims/import", to: "claims#import_show", as: :claim_import
    post "/claims/import", to: "claims#import_submit", as: :claim_import_submit

    resources :claims

    resources :users
    resources :roles, only: [:index, :show]
    resources :category_suggestions do
      patch :approve, as: "approve"
      patch :reject, as: "reject"
      patch :assign_similar_category, as: "assign_similar_category"
    end

    root to: "categories#index" # <--- Root route
  end
end
