Rails.application.routes.draw do
  root                'static_pages#home'
  get 'search'    =>  'search#index'

  get 'events/meetup/:group_id/:event_id', to: 'events#show_meetup'
  get 'events/eventbrite/:event_id', to: 'events#show_eventbrite'
end
