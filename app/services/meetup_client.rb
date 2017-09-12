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
      get(find_events_query(query))
    )
  end

  def categories
    get("/2/categories?#{key_params}")['results']
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

  def find_events_query( query )
    "/2/open_events?#{default_find_params}&#{query_string(query)}"
  end

  def default_find_params
    "#{key_params}&text_format=plain"
  end

  def key_params
    "sign=true&key=#{api_token}"
  end

  def search_params( query )
    if (query[:q])
      ids = category_ids( query )
      if( ids.count > 0 )
        { category: ids.join(',') }
      else
        { text: query[:q] }
      end
    else
      {}
    end
  end

  def category_ids( query )
    MeetupCategory.categories_like( query[:q] )
      .map{ |c| c.id }
  end

  def query_string( query )
    query.except(:q, :time, :lat, :lng)
      .merge(lat_lng_params(query))
      .merge(search_params(query))
      .merge(time_params(query))
      .map{ |k,v| "#{k}=#{v}" }.join('&')
  end

  def validate_find_events_query_string( query )
    raise BadRequest.new("Valid query parameters are: #{valid_find_events_keys}") unless (
      query.keys - valid_find_events_keys == []
    )
  end

  def lat_lng_params( query )
    { lat: query[:lat], lon: query[:lng] }
  end

  def valid_find_events_keys
    [ :lat, :lng, :q, :radius, :time ]
  end

  def time_params( query )
    if( query[:time] && !query[:time].blank? )
      range = query[:time].split(" - ")
        .map{ |d| Date.strptime(d, '%m/%d/%Y') }
        .map{ |d| d.to_time.to_i * 1000 }.join(",")
      { time: range }
    else
      { time: "0d,1d" }
    end
  end

end
