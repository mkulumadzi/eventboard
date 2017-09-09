class SearchController < ApplicationController

  def index
    @events = find_events
  end

  private

  def meetup
    @meetup ||= MeetupClient.new
  end

  def find_events
    meetup.find_events({ lon: params[:lng].to_f, lat: params[:lat].to_f } )
  end

end
