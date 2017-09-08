require 'rails_helper'

describe ApiClient do

  let(:base_uri) { "https://coolapi.io" }

  describe 'initialize' do

    subject { ApiClient.new( base_uri ) }

    it 'stores the base_uri' do
      expect(subject.base_uri).to eq(base_uri)
    end

  end

  describe 'initialization errors' do

    it 'raises a ConfigError if there is no base_uri' do
      expect{
        ApiClient.new(nil)
      }.to raise_error(ApiClient::ConfigError)
    end

  end

  describe 'get' do

    subject { ApiClient.new( base_uri ) }

    before do

      stub_request(:get, %r{anything} ).to_return(body: '{"some": "result"}', status: 200, headers: json_headers )

      stub_request(:get, %r{notfound} ).to_return(body: '{"some": "result"}', status: 404, headers: json_headers )

      stub_request(:get, %r{bad} ).to_return(body: '{"some": "result"}', status: 400, headers: json_headers )

      stub_request(:get, %r{realbad} ).to_return(body: '{"some": "result"}', status: 500, headers: json_headers )
    end

    it 'gets a response and returns the result' do
      result = subject.get("/anything")
      expect(result['some']).to eq("result")
    end

    it 'raises a BadRequest error if the status is 400' do
      expect{
        subject.get("/bad")
      }.to raise_error(ApiClient::BadRequest)
    end

    it 'raises a NotFound error if the status is 404' do
      expect{
        subject.get("/notfound")
      }.to raise_error(ApiClient::NotFound)
    end

    it 'raises a ClientError error if the status is 500' do
      expect{
        subject.get("/realbad")
      }.to raise_error(ApiClient::ClientError)
    end

  end

end
