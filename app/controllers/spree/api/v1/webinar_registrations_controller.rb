module Spree
  module Api
    module V1
      class WebinarRegistrationsController < Spree::Api::BaseController
        before_action :find_registration, only: :show
        before_action :find_registrations, only: [:index, :all]

        def all
          authorize! :all, @webinar_registrations
          respond_with(@webinars)
        end

        def index
          authorize! :all, @webinar_registrations
          respond_with(@webinars)
        end

        def show
          authorize! :show, @webinar_registration
          respond_with(@webinar)
        end

        def create
          authorize! :create, WebinarRegistration
          product = Spree::Product.find_by!(id: params[:webinar_registration][:product_id])
          user = Spree::User.find_by!(id: params[:webinar_registration][:user_id])
          @webinar_registration = Spree::WebinarRegistration.find_or_create_by!(
            user: user,
            product: product
          )
          render nothing: true, status: 201
        end

        private

        def find_registration
          @webinar_registration = Spree::WebinarRegistration.find(params[:id])
        end

        def find_registrations
          @webinar_registrations = Spree::WebinarRegistration.all
        end
      end
    end
  end
end
