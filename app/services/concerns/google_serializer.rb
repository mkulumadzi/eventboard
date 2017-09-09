module GoogleSerializer

  extend ActiveSupport::Concern

  def serialize_predictions( response )
    response["predictions"].map do |r|
      {
        text: r["structured_formatting"]["main_text"],
        place_id: r["place_id"]
      }
    end
  end

  def serialize_details( response )
    {
      name: response['result']['name'],
      lat: response['result']['geometry']['location']['lat'],
      lng: response['result']['geometry']['location']['lng'],
      viewport: response['result']['geometry']['viewport']
    }
  end

end
