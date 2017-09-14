class EventsService

  def find_events( query )
    aggregate_by_date( meetup_events( query ) )
  end

  private

  def aggregate_by_date( events )
    results = {}
    events.map{ |e| e['date'] }.uniq
      .each { |d| results[d] = events.select{ |e| e['date'] == d }}
    results
  end

  def meetup_events( query )
    meetup.find_events( query )
  end

  def meetup
    @meetup ||= MeetupClient.new
  end

end
