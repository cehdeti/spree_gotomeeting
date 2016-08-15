Spree::Api::V1::UsersController.class_eval do
  def webinar_registrations
    @webinar_registrations = Spree::WebinarRegistration.where(user_id: user.id)
    respond_with(@webinar_registrations)
  end
end
