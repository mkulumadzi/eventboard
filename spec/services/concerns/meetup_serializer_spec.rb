require 'rails_helper'

describe MeetupSerializer do

  let (:test_class) { Struct.new(:base_uri) { extend MeetupSerializer } }

  describe 'serialize_meetups' do

    let(:meetups) { load_fixture('meetup/find_events') }
    let(:serialized) { test_class.serialize_meetups(meetups) }

    it 'returns an Array' do
      expect(serialized).to be_instance_of(Array)
    end

    it 'formats the time' do
      expect(serialized[0]['time']).to eq("Tue, Sep 12 2017 at  6:30 pm")
    end

    it 'formats the date' do
      expect(serialized[0]['date']).to eq("Tue, Sep 12")
    end

    it 'generates a relative path' do
      expect(serialized[0]['rel_path']).to eq("events/meetup/Congress-Park-Run-Club/rfvhqnywmbqb")
    end

  end

end
