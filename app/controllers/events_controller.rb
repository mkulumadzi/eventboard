class EventsController < ApplicationController

  def show
    event
  end

  private

  def event
    @event = meetup.event_with_group_details( params[:group_id], params[:event_id] )
  end

end
