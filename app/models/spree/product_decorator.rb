Spree::Product.class_eval do
  validates :webinar_date, presence: true, if: :webinar?

  after_save -> { WebinarToCitrix.new(self).run }, if: :webinar?

  scope :webinar, -> { where(webinar: true) }

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
      response = SpreeGotomeeting.client.class.post('webinars', body: serialized_product)
      webinar_key = webinar_key_from_response(response) || raise('Webinar key not returned from Citrix API')
      product.update_column(:webinar_key, webinar_key) && product.reload
    end

    def update
      SpreeGotomeeting.client.class.put("webinars/#{product.webinar_key}", body: serialized_product)
    end

    def webinar_key_from_response(response)
      res = response.parsed_response
      res['webinarKey'] if res && res['webinarKey'] && !res['webinarKey'].empty?
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
