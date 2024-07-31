Rails.application.routes.draw do
  resources :products
  get 'demo_partials/new'
  get 'demo_partials/edit'
  get 'static_pages/home'
  get 'static_pages/help'
  #config/routes.rb
  scope "(:locale)", locale: /en|vi/ do
    resources :microposts
    resources :users
  end
end
