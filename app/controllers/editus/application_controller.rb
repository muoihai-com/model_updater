module Editus
  class ApplicationController < ActionController::Base
    include ::ApplicationHelper

    before_action :authenticate!, :set_locale

    rescue_from "StandardError" do |exception|
      @exception = exception

      render "editus/supports/bug"
    end

    def authenticate!
      auth = Editus.configuration.auth
      return if auth.blank?
      return if current_account.present?
      return if authenticate(auth)

      request_http_basic_authentication
    end

    def authenticate auth_configs
      authenticate_with_http_basic do |u, p|
        if auth_configs.include?([u, p])
          session[:basic_auth_account] = u
          return true
        end
      end
    end

    def set_locale
      I18n.locale = :en
    end

    def current_account
      session[:basic_auth_account]
    end
  end
end
