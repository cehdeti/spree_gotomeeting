require 'time'

Spree::Admin::ProductsController.class_eval do
  include ActionView::Helpers::SanitizeHelper

  create.before :webinar_create_before
  update.before :webinar_update_before
  create.after :webinar_create_after
  update.after :webinar_update_after

  def webinar_create_before
    check_webinar_before_save
  end

  def webinar_update_before
    check_webinar_before_save
  end

  def webinar_create_after
    check_webinar_saved
  end

  def webinar_update_after
    check_webinar_saved
  end

  private

  def check_webinar_saved
    if @product.is_webinar && !@product.webinar_date.nil?
      if @product.webinar_key.empty?
        make_webinar_in_citrix
      else
        update_webinar_in_citrix
      end
    end
  end

  def check_webinar_before_save
    return unless @product.is_webinar

    if params[:product][:webinar_date] && params[:product][:webinar_date].empty?
      flash[:error] = 'Please specify a date for your webinar'
      false
    end
  end

  def make_webinar_in_citrix

    newwebinar = SpreeGotomeeting.client.class.post('webinars', body: generate_params.to_json)
    webinar_key = parse_response_for_webinar_key(newwebinar)

    return if webinar_key.nil?

    @product.webinar_key=webinar_key
    @product.save
    get_webinar_details
  end

  def update_webinar_in_citrix
    updated_webinar = SpreeGotomeeting.client.class.put("webinars/#{@product.webinar_key}", body: generate_params.to_json)
    updated_key = parse_response_for_webinar_key(updated_webinar)
    get_webinar_details
  end

  def generate_params
    start_time = @product.webinar_date - Time.zone_offset('EST')
    end_time = start_time + 1.hour

    {
      times: [{
        startTime: start_time.strftime("%FT%TZ"),
        endTime: end_time.strftime("%FT%TZ")
      }],
      timezone: 'CST',
      subject: @product.name,
      description: strip_tags(@product.description),
      isPasswordProtected: true
    }
  end

  def parse_response_for_webinar_key(api_response)
    res = api_response.parsed_response
    res['webinarKey'] if res && res['webinarKey'] && !res['webinarKey'].empty?
  end

  def get_webinar_details
    return if @product.webinar_key.empty?

    details = SpreeGotomeeting.client.get_webinar(@product.webinar_key)
    result = details.parsed_response
  end
end
