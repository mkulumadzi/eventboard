class ApiClient

  class ConfigError < RuntimeError; end;
  class NotFound < RuntimeError; end;
  class ClientError < RuntimeError; end;
  class BadRequest < RuntimeError; end;

  CACHE_NAMESPACE = "Base"
  DEFAULT_TTL = 3600

  attr_reader :base_uri

  def initialize( base_uri = nil )
    @base_uri = base_uri
    connection # Build connection and validate that the base_uri is set correctly
  end

  def get( uri )
    cache( uri, ttl: DEFAULT_TTL ) do
      do_request( uri )
    end
  end

  private

  def do_request( uri )
    response = connection.get( uri )

    case( response.status )
    when 200
      response.body
    when 400
      raise( BadRequest )
    when 404
      raise( NotFound )
    else
      raise( ClientError )
    end

  end

  def cache( uri, ttl: nil )
    return yield if ttl.nil? # skip cache

    Cache.cache_store.fetch(
      cache_key(uri),
      expires_in: ttl
    ) { yield }
  end

  def cache_key( uri )
    code = Digest::SHA1.hexdigest( uri )
    "#{CACHE_NAMESPACE}:#{code}"
  end

  def uri
    base_uri || raise(ConfigError.new("Missing base_uri.") )
  end

  def query_string( query )
    query.map{ |k,v| "#{k}=#{v}" }.join('&')
  end

  def connection
    @connection ||= Faraday.new do |f|
      f.request :json
      f.response :json, content_type: /\bjson$/
      f.url_prefix = uri

      f.headers.merge!(
        headers
      )

      f.adapter :excon
    end
  end

  def headers
    {
      'Accept'        => 'application/json',
      'Content-Type'  => 'application/json'
    }
  end

end
