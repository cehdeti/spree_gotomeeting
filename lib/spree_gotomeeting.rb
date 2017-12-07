require 'go_to_webinar'
require 'spree_gotomeeting/engine'
require 'spree_gotomeeting/configuration'

module SpreeGotomeeting
  def self.client

    @client ||= GoToWebinar::Client.new(
      configuration.access_token,
      configuration.organizer_key,
      {:base_uri => configuration.base_uri}
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
