require 'spree_core'
require 'spree_gotomeeting/engine'

module SpreeGotomeeting
  class_attribute :client_id
  class_attribute :consumer_secret
  class_attribute :access_token
  class_attribute :organizer_key
end
