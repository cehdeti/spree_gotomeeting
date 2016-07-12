Spree::Payment.class_eval do
  state_machine initial: :checkout do
    after_transition to: :completed, do: :create_webinar_registrations!
  end

  def create_webinar_registrations!
    order.create_webinar_registrations
  end
end
