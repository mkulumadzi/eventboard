class EventsController < ApplicationController

  def show_meetup
    meetup_event
  end

  def show_eventbrite
    eventbrite_event
  end

  private

  def meetup_event
    @event = meetup.event_with_group_details( params[:group_id], params[:event_id] )
  end

  def eventbrite_event
    @event = eventbrite.event(params[:event_id])
  end

end
