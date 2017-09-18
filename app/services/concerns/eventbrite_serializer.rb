module EventbriteSerializer

  extend ActiveSupport::Concern

  def serialize_events( events )
    events['events'].map{ |e| serialize_event(e) }
  end

  def serialize_event( event )
    event['name'] = event['name']['text']
    event['description'] = event['description']['html']
    event['venue']['latitude'] = event['venue']['latitude'].to_f
    event['venue']['longitude'] = event['venue']['longitude'].to_f
    time, date = time_and_date_strings( event )
    event['time'] = time
    event['date'] = date
    event['class'] = "group_type_#{rand(0..4)}"
    event['rel_path'] = "/events/eventbrite/#{event['id']}"
    event
  end

  private

  def time_and_date_strings( event )
    t = timevalue(event)
    time = t.strftime('%a, %b %d %Y at %l:%M %P')
    date = t.strftime('%a, %b %d')
    [time, date]
  end

  def timevalue( event )
    Time.parse(event['start']['utc'])
  end

end
