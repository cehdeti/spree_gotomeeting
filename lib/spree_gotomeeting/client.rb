require 'http'

module SpreeGotomeeting
  class Client
    BASE_URI = 'https://api.getgo.com/'.freeze
    AUTH_CACHE_KEY = 'spree_gotomeeting_auth'.freeze

    attr_accessor :consumer_token, :consumer_secret, :username, :password
    attr_writer :cache

    def initialize(consumer_token, consumer_secret, username, password, **args)
      self.consumer_token = consumer_token
      self.consumer_secret = consumer_secret
      self.username = username
      self.password = password

      args.each_pair do |attr, value|
        send("#{attr}=", value) if respond_to?("#{attr}=", true)
      end
    end

    %i[get post put delete].each do |method|
      define_method(method) do |uri, **kwargs|
        creds = auth
        HTTP
          .headers(accept: 'application/json')
          .auth("Bearer #{creds['access_token']}")
          .send(method, build_uri(uri) % creds.symbolize_keys, **kwargs)
      end
    end

    def base_uri=(uri)
      return unless uri

      uri = "#{uri}/" unless uri.end_with?('/')
      @base_uri = uri
    end

    private

    def auth
      unless cache.exist?(AUTH_CACHE_KEY)
        data = do_auth
        cache.write(AUTH_CACHE_KEY, data, expires_in: data['expires_in'].seconds)
      end
      cache.read(AUTH_CACHE_KEY)
    end

    def do_auth
      HTTP
        .headers(
          accept: 'application/json',
          content_type: 'application/x-www-form-urlencoded'
        )
        .basic_auth(user: consumer_token, pass: consumer_secret)
        .post(build_uri('/oauth/v2/token'), form: {
          grant_type: 'password',
          username: username,
          password: password
        })
        .parse
    end

    def base_uri
      @base_uri || BASE_URI
    end

    def build_uri(path)
      path = path[1..-1] if path.start_with?('/')
      "#{base_uri}#{path}"
    end

    def cache
      @cache ||= Rails.cache
    end
  end
end
