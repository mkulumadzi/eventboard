require 'rails_helper'

describe EventbriteSerializer do

  let (:test_class) { Struct.new(:base_uri) { extend EventbriteSerializer } }

  describe 'serialize_events' do

    let(:events) { load_fixture('eventbrite/find_events') }
    let(:serialized) { test_class.serialize_events(events) }

    it 'returns an Array' do
      expect(serialized).to be_instance_of(Array)
    end

    it 'formats the time' do
      expect(serialized[0]['time']).to eq("Wed, Oct 11 2017 at  1:00 am")
    end

    it 'formats the date' do
      expect(serialized[0]['date']).to eq("Wed, Oct 11")
    end

    it 'converts the latitude to a float' do
      expect(serialized[0]['venue']['latitude']).to be_instance_of(Float)
    end

    it 'converts the longitude to a float' do
      expect(serialized[0]['venue']['longitude']).to be_instance_of(Float)
    end

    it 'converts the name to a string' do
      expect(serialized[0]['name']).to be_instance_of(String)
    end

    it 'converts the description to a description' do
      expect(serialized[0]['description']).to be_instance_of(String)
    end

  end

end
