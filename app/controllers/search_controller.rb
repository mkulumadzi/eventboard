#
# ToDo Consider combining this with the EventsController
#

class SearchController < ApplicationController

  def index
    # search_radius
    @events = find_events
  end

  private

  def find_events
    meetup.find_events({ lng: params[:lng].to_f, lat: params[:lat].to_f, radius: search_radius, q: params[:q], time: params[:time] } )
  end

  def search_radius
    center = [params[:lat].to_f, params[:lng].to_f]
    corner = [params[:f_b_lat].to_f, params[:b_b_lng].to_f]
    Haversine.distance(center, corner).to_miles.floor
  end

end
