class Spree::WebinarRegistration < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class.to_s
  belongs_to :product, class_name: 'Spree::Product'

  after_save :sync_with_gotomeeting

  private

  def sync_with_gotomeeting
    return if product.webinar_date <= Time.now || registrant_key

    params = {
      firstName: user.bill_address.try(:first_name) || user.email,
      lastName: user.bill_address.try(:last_name) || user.email,
      email: user.email
    }

    data = SpreeGotomeeting.client.post(
      "/G2W/rest/v2/organizers/%{organizer_key}/webinars/#{product.webinar_key}/registrants",
      json: params
    ).parse

    update_columns(
      registration_status: data['status'],
      join_url: data['joinUrl'],
      registrant_key: data['registrantKey']
    ) && reload
  end
end
