# frozen_string_literal: true

ENV['ENVIRONMENT'] ||= ENV['RACK_ENV'] || 'test'

require 'coveralls'
Coveralls.wear!

require 'simplecov'

SimpleCov.start { add_filter('test') }
SimpleCov.minimum_coverage(96)

require 'minitest/autorun'
require 'minitest/reporters'
require 'rack/test'
require 'approvals'
require 'pry'

Approvals.configure do |config|
  config.approvals_path = 'test/fixtures/approvals/'
end

Minitest::Reporters.use!

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class TestApp < Minitest::Test
  include Rack::Test::Methods

  def app
    OUTER_APP
  end
end
