#
# Helper methods to simplify test suite
#

module TestHelper

  def read_fixture( filename )
    File.read( File.join(Rails.root, 'spec', 'fixtures', "#{filename}.json"))
  end

  def load_fixture( filename )
    JSON.parse( read_fixture( filename ) )
  end

  def json_headers
    {
      "Content-type" => "application/json",
      "Accept" => "application/json"
    }
  end

end
