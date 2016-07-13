Spree::Order.class_eval do
  def create_webinar_registrations
    line_items.each do |line_item|
      next unless line_item.variant.product.webinar?

      WebinarRegistration.register!(
        user: user,
        product: line_item.variant.product
      )
    end
  end
end
