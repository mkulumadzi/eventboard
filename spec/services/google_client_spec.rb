require 'rails_helper'

describe GoogleClient do

  describe 'initialize' do

    subject { GoogleClient.new }

    it 'loads the default base_uri' do
      expect(subject.base_uri).to eq("https://maps.googleapis.com/maps/api/place")
    end

    it 'raises an error if the GOOGLE_API_TOKEN is missing' do
      ClimateControl.modify GOOGLE_API_TOKEN: nil do
        expect{
          GoogleClient.new
        }.to raise_error(GoogleClient::ConfigError)
      end
    end

  end

  describe 'autocomplete' do

    let(:query) { "d" }
    let(:predictions) { subject.autocomplete( query ) }

    before do
      stub_request(:get, %r{autocomplete} ).to_return(body: read_fixture('google/d'), status: 200, headers: json_headers )
    end

    it 'returns an array of predictions' do
      expect(predictions).to be_instance_of(Array)
    end

    it 'serialize_predictions' do
      expect(subject).to receive(:serialize_predictions)
      predictions
    end

  end

  describe 'details' do

    let(:place_id) { "ChIJzxcfI6qAa4cR1jaKJ_j0jhE" }
    let(:details) { subject.details( place_id ) }

    before do
      stub_request(:get, %r{details} ).to_return(body: read_fixture('google/denver_details'), status: 200, headers: json_headers )
    end

    it 'returns a Hash' do
      expect(details).to be_instance_of(Hash)
    end

    it 'serialize_details' do
      expect(subject).to receive(:serialize_details)
      details
    end

  end

end
