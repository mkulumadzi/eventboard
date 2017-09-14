class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def events_service
    @events_service ||= EventsService.new
  end

end
