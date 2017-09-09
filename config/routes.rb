Rails.application.routes.draw do
  root                'static_pages#home'
  get 'search'    =>  'search#index'
end
