class MeetupClient < ApiClient

  BASE_URI = "https://api.meetup.com"

  include MeetupSerializer

  def initialize
    api_token # Ensure we have the api token
    super
  end

  def find_events( query )
    validate_find_events_query_string( query )
    serialize_meetups(
      get("/find/events?#{key_params}&#{query_string(query)}")
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
    @api_token ||= ENV['MEETUP_API_TOKEN'] || raise(ConfigError.new("Missing MEETUP_API_TOKEN environment variable") )
  end

  def query_string( query )
    query.map{ |k,v| "#{k}=#{v}" }.join('&')
  end

  def key_params
    "sign=true&key=#{api_token}"
  end

  def validate_find_events_query_string( query )
    raise BadRequest.new("Valid query parameters are: #{valid_find_events_keys}") unless (
      query.keys - valid_find_events_keys == []
    )
  end

  def valid_find_events_keys
    [ :lat, :lon, :text, :radius ]
  end

end
