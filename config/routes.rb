Rails.application.routes.draw do
  only_path: true
  resources :cello_masters
  devise_for :users
  post '/upload_csv', to: 'cello_masters#upload_csv', as: 'upload_csv'
  root to: 'cello_masters#index'
end
