module Spree
  Product.class_eval do

#    has_many :account_subscriptions, foreign_key: "product_id"


#    scope :subscribable, -> { where(subscribable: true) }
#    scope :unsubscribable, -> { where(subscribable: false) }
  end
end
