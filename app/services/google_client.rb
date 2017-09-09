class GoogleClient < ApiClient

  BASE_URI = "https://maps.googleapis.com/maps/api/place"

  include GoogleSerializer

  def initialize
    api_token # Ensure we have the api token
    super
  end

  def autocomplete( query )
    serialize_predictions(
      get("/autocomplete/json?input=#{query}&#{key_params}")
    )
  end

  def details( place_id )
    serialize_details(
      get("/details/json?placeid=#{place_id}&#{key_params}")
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
    @api_token ||= ENV['GOOGLE_API_TOKEN'] || raise(ConfigError.new("Missing GOOGLE_API_TOKEN environment variable") )
  end

  def key_params
    "key=#{api_token}"
  end

end
