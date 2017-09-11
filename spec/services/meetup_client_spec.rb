require 'rails_helper'

describe MeetupClient do

  describe 'initialize' do

    subject { MeetupClient.new }

    it 'loads the default base_uri' do
      expect(subject.base_uri).to eq("https://api.meetup.com")
    end

    it 'raises an error if the MEETUP_API_TOKEN is missing' do
      ClimateControl.modify MEETUP_API_TOKEN: nil do
        expect{
          MeetupClient.new
        }.to raise_error(MeetupClient::ConfigError)
      end
    end

  end

  describe 'find events' do

    let(:query) { { lon: -105.027464, lat: 39.752422 } }

    let(:events) { subject.find_events(query) }

    before do
      stub_request(:get, %r{find/events} ).to_return(body: read_fixture('meetup/find_events'), status: 200, headers: json_headers )
    end

    it 'returns an array of nearby events' do
      expect(events).to be_instance_of(Array)
    end

    it 'serializes meetups' do
      expect(subject).to receive(:serialize_meetups)
      events
    end

    it 'raises an error if invalid keys are included' do
      query[:some_other_key] = "some other value"
      expect{
        subject.find_events(query)
      }.to raise_error(MeetupClient::BadRequest)
    end

  end

end
