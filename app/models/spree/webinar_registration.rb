class Spree::WebinarRegistration < ActiveRecord::Base
  belongs_to :user, class_name: Spree.user_class
  belongs_to :product, class_name: 'Spree::Product'

  after_save :sync_with_citrix

  def self.register!(opts)
    opts.to_options!.assert_valid_keys(:user, :product)
    existing_registration = where(user_id: opts[:user].id, product_id: opts[:product].id).first

    if existing_registration
      existing_registration.user = opts[:user]
      existing_registration.product = opts[:product]
      existing_registration.save
    else
      new_registration(opts[:user], opts[:product])
    end
  end

  private

  def self.new_registration(user, webinar)
    create do |r|
      r.user = user
      r.product = webinar
      r.registrant_key = nil
      r.registration_status = nil
      r.join_url = nil
    end
  end

  def sync_with_citrix
    Logger.debug("syncing with citrix:: #{registrant_key}")
    return if product.webinar_date <= Time.now || registrant_key


    params = {
      firstName: self.user.bill_address ? self.user.bill_address.first_name : 'firstname',
      lastName: self.user.bill_address ? self.user.bill_address.last_name : 'lastname',
      email: self.user.email
    }

    url = "/webinars/#{self.product.webinar_key}/registrants"
    to_citrix = SpreeGotomeeting.client.class.post(url, body: params.to_json)
    Logger.debug("TOCITRICX Response #{to_citrix} and parsed response #{to_citrix.parsed_response}")
    data = to_citrix.parsed_response

    update_columns(
      registration_status: data['status'],
      join_url: data['joinUrl'],
      registrant_key: data['registrantKey']
    ) && reload
  end
end
