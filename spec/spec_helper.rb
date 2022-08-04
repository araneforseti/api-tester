# frozen_string_literal: true

require 'rspec'
require 'require_all'
require 'webmock/rspec'
require 'simplecov'
require "simplecov_json_formatter"

SimpleCov.formatter = SimpleCov::Formatter::JSONFormatter
SimpleCov.start do
  enable_coverage :branch
end

require 'api-tester'
require_all 'lib/**/*.rb'

RSpec.configure do |config|
  config.after(:each) do
    WebMock.reset!
  end
end

def test_helper_mock
  Class.new(ApiTester::TestHelper) do
    def initialize
      super ''
    end

    def before
      RestClient.get('www.test.com/before')
    end

    def after
      RestClient.get('www.test.com/after')
    end
  end
end
