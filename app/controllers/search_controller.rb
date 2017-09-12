class SearchController < ApplicationController

  def index
    search_radius
    @events = find_events
  end

  private

  def meetup
    @meetup ||= MeetupClient.new
  end

  def find_events
    meetup.find_events({ lon: params[:lng].to_f, lat: params[:lat].to_f, radius: search_radius, q: params[:q] } )
  end

  def search_radius
    center = [params[:lat].to_f, params[:lng].to_f]
    corner = [params[:f_b_lat].to_f, params[:b_b_lng].to_f]
    Haversine.distance(center, corner).to_miles.floor
  end

end
