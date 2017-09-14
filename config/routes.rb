Rails.application.routes.draw do
  root                'static_pages#home'
  get 'search'    =>  'search#index'
  get 'events/meetup/:group_id/:event_id', to: 'events#show', as: 'event'
end
