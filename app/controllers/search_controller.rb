#
# ToDo Consider combining this with the EventsController
#

class SearchController < ApplicationController

  def index
    @events = find_events
  end

  private

  def find_events
    events_service.find_events({ lng: params[:lng].to_f, lat: params[:lat].to_f, radius: params[:radius], q: params[:q], time: params[:time] } )
  end

end
