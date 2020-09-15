Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  default_url_options :host => "https://karnavati.herokuapp.com"
  resources :cello_masters
  resources :emails, only: :new
  post '/send_email', to: 'emails#send_email', as: 'send_email'
  devise_for :users
  post '/download_pdf', to: 'cello_masters#download_pdf', as: 'download_pdf', defaults: { format: :pdf }
  get '/download_image', to: 'cello_masters#download_image', as: 'download_image', defaults: { format: :jpg }
  post '/upload_csv', to: 'cello_masters#upload_csv', as: 'upload_csv'
  patch '/update_discount', to: 'cello_masters#update_discount'
  get '/search_data', to: 'cello_masters#search_data'
  root to: 'cello_masters#index'
end
