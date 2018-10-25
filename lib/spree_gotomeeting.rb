require 'spree_gotomeeting/engine'
require 'spree_gotomeeting/client'
require 'spree_gotomeeting/configuration'

module SpreeGotomeeting
  def self.client
    @client ||= SpreeGotomeeting::Client.new(
      configuration.consumer_token,
      configuration.username,
      configuration.password,
      base_uri: configuration.base_uri
    )
  end

  def self.configure
    yield configuration
  end

  def self.configuration
    @config ||= Configuration.new
  end

  def self.reset!
    @config = nil
    @client = nil
  end
end
