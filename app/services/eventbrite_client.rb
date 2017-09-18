class EventbriteClient < ApiClient

  BASE_URI = "https://www.eventbriteapi.com"

  include EventbriteSerializer

  def initialize
    api_token # Ensure we have the api token
    super
  end

  def find_events( query )
    serialize_events(
      get("/v3/events/search/?#{find_events_query(query)}")
    )
  end

  def event( event_id )
    serialize_event(
      get("/v3/events/#{event_id}/?expand=venue")
    )
  end

  private

  #
  # Hard-code the meetup api client uri
  #
  def uri
    @base_uri ||= BASE_URI
  end

  def api_token
    @api_token ||= ENV['EVENTBRITE_API_TOKEN'] || raise(ConfigError.new("Missing EVENTBRITE_API_TOKEN environment variable") )
  end

  #
  # The Eventbrite /events/search endpoint does not work if you pass in the 'Accept' and 'Content-Type headers.'
  #

  def headers
    {
      'Authorization'   => "Bearer #{ENV['EVENTBRITE_API_TOKEN']}"
    }
  end

  def find_events_query query
    query_string( find_events_query_params( query ) )
  end

  def radius( query )
    query[:radius] || 20
  end

  def find_events_query_params query
    {
      "location.latitude" => query[:lat],
      "location.longitude" => query[:lng],
      "expand" => "venue",
      "location.within" => "#{radius(query)}mi",
      "q" => query[:q]
    }.merge(time_params(query))
    .compact
  end

  def time_params( query )
    if( query[:time] && !query[:time].blank? )
      range = query[:time].split(" - ")
        .map{ |d| Date.strptime(d, '%m/%d/%Y') }
        .map{ |d| d.strftime("%Y-%m-%dT%H:%M:%S") }

      {
        "start_date.range_start" => range[0],
        "start_date.range_end" => range[1],
      }
    else
      { "start_date.keyword" => "today" }
    end
  end

end
