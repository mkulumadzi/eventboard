class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private
  
  def meetup
    @meetup ||= MeetupClient.new
  end

end
