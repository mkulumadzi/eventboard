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
      expect(serialized[0]['time']).to eq("Fri, Sep 2017 at 11:00 am")
    end

    it 'removes html tags from the description' do
      expect(serialized[0]['description']).to eq("This September Lipstick Tactical will be kicking off a series of lunch and learns. This month's topic is BARRIERS TO GOAL ATTAINMENT. We will discuss things that get in between us and our goals and how to navigate those barriers and distractions much like we have to do while on the range and staying focused on our targets!!")
    end

  end

end
