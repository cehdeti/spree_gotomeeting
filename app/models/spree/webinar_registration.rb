class Spree::WebinarRegistration < ActiveRecord::Base

  include GoToWebinar

  belongs_to :user, class_name: Spree.user_class
  belongs_to :product, class_name: 'Spree::Product'

  after_save :sync_with_citrix

  def self.register!(opts)

    opts.to_options!.assert_valid_keys(:user, :product)

    existing_registration = self.where(user_id: opts[:user].id, product_id: opts[:product].id).first

    if existing_registration
      existing_registration.user = opts[:user]
      existing_registration.product = opts[:product]
      existing_registration.save
    else
      self.new_registration(opts[:user], opts[:product])
    end

    return self
  end



  private

  def self.new_registration(user, webinar)
    self.create do |r|
      r.user = user
      r.product = webinar
      r.registrant_key=nil
      r.registration_status=nil
      r.join_url = nil
    end
  end

  def sync_with_citrix
    puts "syncing with citrix! #{self}"

    if !self.registrant_key
      puts "no registrant key, check with citrix"
      @g2w = GoToWebinar::Client.new( Spree::GoToMeeting::ACCESS_TOKEN, Spree::GoToMeeting::ORGANIZER_KEY)

      params = {
          :firstName => self.user.bill_address.first_name,
          :lastName => self.user.bill_address.last_name,
          :email => 'saun0063@umn.edu'
      }
      puts "data: #{params}"
      url = "webinars/#{self.product.webinar_key}/registrants"

      to_citrix = @g2w.class.post(url, :body => params.to_json)

      data = to_citrix.parsed_response
      puts "RESPONSE #{data} qqq #{data['registrantKey']} 222 #{data[:registrantKey]}"

      self.registrant_key = data['registrantKey']
      self.join_url = data['joinUrl']
      self.registration_status = data['status']
      self.save
      puts "UPDATED all!!"
    else
      puts "NO SYNC, record already has registrant key"
    end

  end

end
