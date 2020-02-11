Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "winnow#index"
  patch "/", to: "winnow#submit", as: :winnow_submit

  resources :categories
end
