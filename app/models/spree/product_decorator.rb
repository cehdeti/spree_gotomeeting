Spree::Product.class_eval do

  after_save :save_to_gotomeeting, if: :webinar?

  scope :webinar, -> { where(webinar: true) }

  private

  def save_to_gotomeeting
    return unless webinar_date && webinar_date > Time.zone.now
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
        json: serialized_product
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
      {
        times: [{
          startTime: product.webinar_date.utc.iso8601,
          endTime: (product.webinar_date + 1.hour).utc.iso8601
        }],
        timezone: Time.zone.now.zone,
        subject: product.name,
        description: ActionView::Base.full_sanitizer.sanitize(product.description, encode_special_chars: false),
        isPasswordProtected: true
      }
    end
  end
end
