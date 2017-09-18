require 'webmock/rspec'
require 'test_helper'
require 'climate_control'

RSpec.configure do |config|

  #
  # Set custom environment variables
  #
  config.around(:each) do |example|
    ClimateControl.modify(
      MEETUP_API_TOKEN: 'abc',
      EVENTBRITE_API_TOKEN: 'def'
    ) do
      example.run
    end
  end

  config.before(:all) do
    # Prevent external connections
    WebMock.disable_net_connect!(allow_localhost: true)
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.include TestHelper

end
