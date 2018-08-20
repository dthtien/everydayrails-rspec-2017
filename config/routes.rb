Rails.application.routes.draw do
  devise_for :users
  get 'pages/home'
  root 'pages#home'
  resources :contacts do
    member do
      patch :hide_contact
    end
    resources :phones
  end
end
