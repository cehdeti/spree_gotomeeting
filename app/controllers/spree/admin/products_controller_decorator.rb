Spree::Admin::ProductsController.class_eval do

  include GoToWebinar
  include ActionView::Helpers::SanitizeHelper
  require 'time'

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

  def setup_citrix
    @g2w = GoToWebinar::Client.new( Spree::GoToMeeting::ACCESS_TOKEN, Spree::GoToMeeting::ORGANIZER_KEY)
  end

  def check_webinar_saved

    if @product.is_webinar
      if !@product.webinar_date.nil?
        if @product.webinar_key.empty?
          make_webinar_in_citrix
        else
          update_webinar_in_citrix
        end
      end
    end
  end

  def check_webinar_before_save

    if @product.is_webinar
      if params[:product][:webinar_date] && params[:product][:webinar_date].empty?
        flash[:error]='Please specify a date for your webinar'
        false
      end
    end
  end

  def make_webinar_in_citrix
    setup_citrix

    params = generate_params

    newwebinar = @g2w.class.post('webinars', :body => params.to_json)

    webinar_key = parse_response_for_webinar_key(newwebinar)

    if !webinar_key.nil?
      @product.webinar_key=webinar_key
      @product.save

      get_webinar_details
    end
  end

  def update_webinar_in_citrix

    setup_citrix

    params = generate_params

    updated_webinar = @g2w.class.put('webinars/'.concat(@product.webinar_key), :body => params.to_json)

    updated_key = parse_response_for_webinar_key ( updated_webinar )

    get_webinar_details
  end

  def generate_params

    startTime = @product.webinar_date - Time.zone_offset('EST')
    endTime = startTime + 1.hour

    params = {
        :times => [:startTime=>startTime.strftime("%FT%TZ"), :endTime=> endTime.strftime("%FT%TZ")],
        :timezone => 'CST',
        :subject => @product.name,
        :description => strip_tags(@product.description),
        :isPasswordProtected => true
    }

    params
  end



  def parse_response_for_webinar_key( api_response )

    res = api_response.parsed_response
    key = nil

    if res && res['webinarKey'] && !res['webinarKey'].empty?
      key = res['webinarKey']
    end

    key
  end


  def get_webinar_details

    if !@product.webinar_key.empty?
      details = @g2w.get_webinar( @product.webinar_key)

      result = details.parsed_response
    end


  end


end
