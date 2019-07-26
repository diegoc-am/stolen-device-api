# frozen_string_literal: true

ENV['ENVIRONMENT'] ||= ENV['RACK_ENV'] || 'development'

require 'dotenv'
require 'deep_open_struct'

Dotenv.load(*Dir['config/.env.local', "config/.env.#{ENV['ENVIRONMENT']}"])

class Config
  CONFIG = DeepOpenStruct.new(
    mysql: {
      url: ENV.fetch('MYSQL_URL'),
      max_connections: ENV.fetch('MYSQL_MAX_CONNECTIONS')
    },
    logger: { level: ENV.fetch('LOG_LEVEL') }
  ).freeze

  private_constant :CONFIG

  # :nocov:
  class << self
    def method_missing(method_name, *args, &block)
      if CONFIG.respond_to?(method_name)
        CONFIG.public_send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, *args)
      CONFIG.respond_to?(method_name) || super
    end
  end
  # :nocov:
end
