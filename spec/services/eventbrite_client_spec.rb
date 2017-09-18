require 'rails_helper'

describe EventbriteClient do

  describe 'initialize' do

    it 'loads the default base_uri' do
      expect(subject.base_uri).to eq("https://www.eventbriteapi.com")
    end

    it 'raises an error if the EVENTBRITE_API_TOKEN is missing' do
      ClimateControl.modify EVENTBRITE_API_TOKEN: nil do
        expect{
          EventbriteClient.new
        }.to raise_error(EventbriteClient::ConfigError)
      end
    end

  end

  describe 'find events' do

    let(:query) { { lng: -105.027464, lat: 39.752422 } }

    let(:events) { subject.find_events(query) }

    before do
      stub_request(:get, %r{events/search} ).to_return(body: read_fixture('eventbrite/find_events'), status: 200, headers: json_headers )
    end

    it 'returns an array of nearby events' do
      expect(events).to be_instance_of(Array)
    end

    it 'serializes the events' do
      expect(subject).to receive(:serialize_events)
      events
    end

    describe 'time params' do

      it 'searches for events in the next 24 hours by default' do
        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("start_date.keyword=today")
        end.and_return(load_fixture('eventbrite/find_events'))

        subject.find_events(query)
      end

      it 'generates range parameters if a time parameter was passed' do
        query.merge!(time: "09/07/2017 - 09/20/2017")

        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("start_date.range_start=2017-09-07T00:00:00&start_date.range_end=2017-09-20T00:00:00")
        end.and_return(load_fixture('eventbrite/find_events'))

        subject.find_events(query)
      end

    end

  end

  describe 'event' do

    let(:event) { subject.event("abc") }

    before do
      stub_request(:get, %r{events/abc} ).to_return(body: read_fixture('eventbrite/event'), status: 200, headers: json_headers )
    end

    it 'returns the event as a Hash' do
      expect(event).to be_instance_of(Hash)
    end

    it 'serializes the event' do
      expect(subject).to receive(:serialize_event)
      event
    end

  end


end
