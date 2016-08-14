Spree::Product.class_eval do
  validates :webinar_date, if: :webinar?,
            presence: true,
            timeliness: {
              on_or_after: Time.zone.now, on_or_after_message: 'cannot be in the past',
              type: :datetime
            }

  after_save :save_to_citrix, if: :webinar?

  scope :webinar, -> { where(webinar: true) }

  private

  def save_to_citrix
    WebinarToCitrix.new(self).run
  rescue => ex
    logger.error("Error saving webinar to Citrix API: #{ex.message}")
  end

  class WebinarToCitrix
    attr_accessor :product

    def initialize(product)
      self.product = product
    end

    def run
      product.webinar_key.empty? ? create : update
    end

    private

    def create
      puts "CREATING NEW WEBINAR #{self.product}"
      response = SpreeGotomeeting.client.class.post('/webinars', body: serialized_product)
      product.update_column(:webinar_key, webinar_key_or_fail(response)) && product.reload
    end

    def update
      puts "UPDATING WEBINAR! #{self.product}"
      response = SpreeGotomeeting.client.class.put("/webinars/#{product.webinar_key}", body: serialized_product)
      webinar_key_or_fail(response)
    end

    def webinar_key_or_fail(response)
      res = response.parsed_response

      case
      when res.include?('webinarKey') then res['webinarKey']
      when res.include?('errorCode') then raise("#{res['description']}: #{res['Details']}")
      else raise("Unexpected response from Citrix API: #{res}")
      end
    end

    def serialized_product
      start_time = product.webinar_date - Time.zone_offset('EST')
      end_time = start_time + 1.hour

      {
        times: [{
          startTime: start_time.strftime("%FT%TZ"),
          endTime: end_time.strftime("%FT%TZ")
        }],
        timezone: 'CST',
        subject: product.name,
        description: ActionView::Base.full_sanitizer.sanitize(product.description, encode_special_chars: false),
        isPasswordProtected: true
      }.to_json
    end
  end
end
