Spree::Product.class_eval do

  after_save :save_to_citrix, if: :webinar?

  scope :webinar, -> { where(webinar: true) }

  private

  def save_to_citrix
    WebinarToGotomeeting.new(self).run
  end

  class WebinarToGotomeeting
    attr_accessor :product

    def initialize(product)
      self.product = product
    end

    def run
      product.webinar_key.empty? ? create : update
    end

    private

    def create
      response = SpreeGotomeeting.client.post(
        '/G2W/rest/v2/organizers/%{organizer_key}/webinars',
        json: serialized_product
      )
      response_ok_or_fail(response)
      product.update_column(:webinar_key, response.parse['webinarKey']) && product.reload
    end

    def update
      response = SpreeGotomeeting.client.put(
        "/G2W/rest/v2/organizers/%{organizer_key}/webinars/#{product.webinar_key}",
        body: serialized_product
      )
      response_ok_or_fail(response)
    end

    def response_ok_or_fail(response)
      return unless response.code >= 400
      res = response.parse

      raise("#{res['description']}: #{res['details']}") if res.include?('errorCode')
      raise("Unexpected response from Citrix API: #{res}")
    end

    def serialized_product
      start_time = product.webinar_date - Time.zone_offset('CST')
      end_time = start_time + 1.hour

      {
        times: [{
          startTime: start_time.strftime('%FT%TZ'),
          endTime: end_time.strftime('%FT%TZ')
        }],
        timezone: 'CST',
        subject: product.name,
        description: ActionView::Base.full_sanitizer.sanitize(product.description, encode_special_chars: false),
        isPasswordProtected: true
      }
    end
  end
end
