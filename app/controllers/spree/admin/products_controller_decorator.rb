Spree::Admin::ProductsController.class_eval do

  include GoToWebinar
  include ActionView::Helpers::SanitizeHelper
  require 'time'

  create.before :webinar_create_before
  update.before :webinar_update_before
  create.after :webinar_create_after
  update.after :webinar_update_after

  def webinar_create_before

    puts "create before!"

    check_webinar_before_save
  end

  def webinar_update_before

    puts "update before!"

    dosave = check_webinar_before_save

    dosave
  end



  def webinar_create_after

    puts 'Create after!'
    check_webinar_saved
  end

  def webinar_update_after

    puts "update after! #{@product}"

    check_webinar_saved

  end


  private


    def check_webinar_saved
      puts "CHECKING FOR WEBINAR #{@product}"

      if @product.is_webinar
        if !@product.webinar_date.nil?
          if @product.webinar_key.nil?
            puts "IS WEBINAR, HAS DATE, BUT NO WEBINAR KEY!"
            make_webinar_in_citrix
          else
            puts "IS WEBINAR, BUT ALREADY HAS KEY"
            make_webinar_in_citrix
          end
        end
      end
    end

    def check_webinar_before_save

      if @product.is_webinar
        if params[:product][:webinar_date].empty?
          flash[:error]='Please specify a date for your webinar'
          false
        end
      end
    end

    def make_webinar_in_citrix

      @g2w = GoToWebinar::Client.new( Spree::GoToMeeting::ACCESS_TOKEN, Spree::GoToMeeting::ORGANIZER_KEY)
#2016-08-01T13:30:00Z


      startTime = @product.webinar_date - Time.zone_offset('EST')
      endTime = startTime + 1.hour
      params = {
          :times=>[:startTime=>startTime.strftime("%FT%TZ"), :endTime=> endTime.strftime("%FT%TZ")],
          :timezone=>'CST',
          :subject=>@product.name,
          :description=> strip_tags(@product.description)
      }

      puts "pARAMS: #{params.to_json}"

      newwebinar = @g2w.class.post('webinars', :body => params.to_json)

      res = newwebinar.parsed_response

      puts "RESpONSe: #{res}"

      if res['webinarKey'] && !res['webinarKey'].empty?
        new_webinar_key = res['webinarKey']
        @product.webinar_key=new_webinar_key
        @product.save

        puts "NEW WEBINAR KEY #{new_webinar_key}"
      end

    end
end
