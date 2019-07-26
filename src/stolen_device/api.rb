# frozen_string_literal: true

require 'grape'
require 'logger'

require_relative 'connections'

module StolenDevice
  ##
  # Main API instatiation
  class API < Grape::API
    LOGGER = Logger.new(STDOUT).tap { |l| l.level = Config.logger.level }.freeze
    format :json
    prefix :api

    get '/status' do
      { status: :ok }.tap do |h|
        h[:mysql_online] = begin
          Connections.mysql.test_connection
                           # :nocov:
                           rescue StandardError => e
                             LOGGER.error(e.message)
                             false
          # :nocov:
        end
      end
    end
  end
end
