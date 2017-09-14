class EventsController < ApplicationController

  def show
    @event = find_event
  end

  private

  def find_event
    meetup.event_with_group_details( params[:group_id], params[:event_id] )
  end

end
