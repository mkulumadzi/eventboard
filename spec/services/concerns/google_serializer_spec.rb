require 'rails_helper'

describe GoogleSerializer do

  let (:test_class) { Struct.new(:base_uri) { extend GoogleSerializer } }

  describe 'serialize_predictions' do

    let(:d) { load_fixture('google/d') }
    let(:serialized) { test_class.serialize_predictions(d) }

    it 'returns an Array' do
      expect(serialized).to be_instance_of(Array)
    end

    it 'returns the main_text as text' do
      expect(serialized[0][:text]).to eq("Denver")
    end

    it 'returns the place_id' do
      expect(serialized[0][:place_id]).to eq("ChIJzxcfI6qAa4cR1jaKJ_j0jhE")
    end

  end

  describe 'serialize details' do

    let(:denver) { load_fixture('google/denver_details')}
    let(:serialized) { test_class.serialize_details(denver) }

    it 'returns a Hash' do
      expect(serialized).to be_instance_of(Hash)
    end

    it 'returns the name' do
      expect(serialized[:name]).to eq("Denver")
    end

    it 'returns the lat' do
      expect(serialized[:lat]).to eq(39.7392358)
    end

    it 'returns the lng' do
      expect(serialized[:lng]).to eq(-104.990251)
    end

  end

end
