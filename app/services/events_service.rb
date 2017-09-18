class EventsService

  def find_events( query )
    aggregate_by_date( events( query ) )
  end

  private

  def aggregate_by_date( events )
    results = {}
    events.map{ |e| e['date'] }.uniq
      .each { |d| results[d] = events_on_date(d, events)}
    results
  end

  def events_on_date( date, events )
    events
      .select{ |e| e['date'] == date }
      .sort{ |a,b| a['time'] <=> b['time'] }
  end

  def events( query )
    meetup_events( query ) + eventbrite_events( query )
  end

  def meetup_events( query )
    meetup.find_events( query )
  end

  def eventbrite_events( query )
    eventbrite.find_events( query )
  end

  def meetup
    @meetup ||= MeetupClient.new
  end

  def eventbrite
    @eventbrite ||= EventbriteClient.new
  end

end
