module Spree
  module Api
    module V1
      class WebinarsController < Spree::Api::BaseController
        before_action :find_webinar, only: :show
        before_action :get_webinars, only: [:index, :all]

        def all
          authorize! :all, @webinars
          respond_with(@webinars)
        end

        def index
          authorize! :all, @webinars
          respond_with(@webinars)
        end

        def show
          authorize! :show, @webinar
          respond_with(@webinar)
        end

        private

        def find_webinar
          @webinar = Spree::Product.includes(:product_properties).find(params[:id])
        end

        def get_webinars
          @webinars = Spree::Product.includes(:product_properties).webinar.order(webinar_date: :desc)
        end
      end
    end
  end
end
