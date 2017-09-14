require 'rails_helper'

describe MeetupClient do

  describe 'initialize' do

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

  describe 'categories' do

    let(:categories) { subject.categories }

    before do
      stub_request(:get, %r{categories} ).to_return(body: read_fixture('meetup/categories'), status: 200, headers: json_headers )
    end

    it 'returns an array' do
      expect(categories).to be_instance_of(Array)
    end

    it 'returns the details of each category as a hash' do
      category = categories[0]
      expect(category).to be_instance_of(Hash)
    end

  end

  describe 'find events' do

    let(:query) { { lng: -105.027464, lat: 39.752422 } }

    let(:events) { subject.find_events(query) }

    before do
      stub_request(:get, %r{open_events} ).to_return(body: read_fixture('meetup/find_events'), status: 200, headers: json_headers )
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

    describe 'search query' do

      before do
        @s = MeetupCategory.create!(name: "Sports")
        @a = MeetupCategory.create!(name: "Arts and Crafts")
      end

      it 'includes a text term if there is a search term and it does not match any categories' do
        query.merge!({q: "Puppies"})
        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("text=Puppies")
        end.and_return(load_fixture('meetup/find_events'))

        subject.find_events(query)
      end

      it 'includes category id if the search term matches a category' do
        query.merge!({q: "sports"})
        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("category=#{@s.id}")
        end.and_return(load_fixture('meetup/find_events'))

        subject.find_events(query)
      end

      it 'includes multiple category ids if the search term matches multiple categories' do
        query.merge!({q: "sports and crafts"})
        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("category=#{@s.id},#{@a.id}")
        end.and_return(load_fixture('meetup/find_events'))

        subject.find_events(query)
      end

    end

    describe 'time params' do

      it 'searches for events in the next 24 hours by default' do
        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("time=0d,1d")
        end.and_return(load_fixture('meetup/find_events'))

        subject.find_events(query)
      end

      it 'searches for events in the next 24 hours if time is blank' do
        query.merge!(time: "")
        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("time=0d,1d")
        end.and_return(load_fixture('meetup/find_events'))

        subject.find_events(query)
      end

      it 'generates millisecond timestamps if a time range parameter is provided' do
        query.merge!(time: "09/07/2017 - 09/20/2017")

        expect(subject).to receive(:get) do |*args|
          expect(args[0]).to include("time=1504764000000,1505887200000")
        end.and_return(load_fixture('meetup/find_events'))

        subject.find_events(query)
      end

    end

  end

  describe 'event' do

    let(:event) { subject.event("groupid", "eventid") }

    before do
      stub_request(:get, %r{event} ).to_return(body: read_fixture('meetup/event'), status: 200, headers: json_headers )
    end

    it 'returns the event as a Hash' do
      expect(event).to be_instance_of(Hash)
    end

    it 'serializes the meetup' do
      expect(subject).to receive(:serialize_meetup)
      event
    end

  end

  describe 'group' do

    let(:group) { subject.group("groupid") }

    before do
      stub_request(:get, %r{groupid} ).to_return(body: read_fixture('meetup/group'), status: 200, headers: json_headers )
    end

    it 'returns the group as a Hash' do
      expect(group).to be_instance_of(Hash)
    end

  end

  describe 'event_with_group_details' do

    let(:event) { subject.event_with_group_details('group_id', 'event_id')}

    before do
      stub_request(:get, %r{group_id} ).to_return(body: read_fixture('meetup/group'), status: 200, headers: json_headers )

      stub_request(:get, %r{event} ).to_return(body: read_fixture('meetup/event'), status: 200, headers: json_headers )
    end

    it 'returns the event as a Hash' do
      expect(event).to be_instance_of(Hash)
    end

    it 'serializes the meetup' do
      expect(subject).to receive(:serialize_meetup).and_return({})
      event
    end

    it 'serializes the meetup with the group' do
      expect(subject).to receive(:serialize_meetup_with_group)
      event
    end

  end

end
