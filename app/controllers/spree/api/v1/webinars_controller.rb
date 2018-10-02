module Spree
  module Api
    module V1
      class WebinarsController < Spree::Api::BaseController
        before_action :find_webinar, only: :show
        before_action :find_webinars, only: [:index, :all]

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
          @webinar = webinar_scope.find(params[:id])
        end

        def find_webinars
          @webinars = webinar_scope.order(webinar_date: :desc)
        end

        def webinar_scope
          Spree::Product
            .includes(:product_properties)
            .webinar
            .available
            .where.not(webinar_date: nil)
        end
      end
    end
  end
end
