Rails.application.routes.draw do
  resources :cello_masters
  devise_for :users
  root to: 'cello_masters#index'
end
