module Spree
  Order.class_eval do


    def create_webinar_registrations
      line_items.each do |line_item|
        if line_item.variant.product.is_webinar?
          WebinarRegistration.register!(
            user: self.user,
            product: line_item.variant.product
          )
        end
      end
    end
  end
end
