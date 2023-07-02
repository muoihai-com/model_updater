module Editus
  class ApplicationController < ActionController::Base
    prepend ::ApplicationHelper

    before_action :authenticate!, :set_locale

    rescue_from "StandardError" do |exception|
      @exception = exception

      render "editus/supports/bug"
    end

    def authenticate!
      return if editus_auth_account.present?
      return head 401 if editus_account_needed?
      return if authenticate(Editus.configuration.auth)

      request_http_basic_authentication
    end

    def authenticate auth_configs
      return true if auth_configs.blank?

      authenticate_with_http_basic do |u, p|
        session[:basic_auth_account] = u if auth_configs.include?([u, p])
      end
    end

    def set_locale
      I18n.locale = :en
    end

    private

    def editus_account_needed?
      ::ApplicationHelper.method_defined?(:editus_account)
    end

    def editus_auth_account
      if editus_account_needed?
        editus_account if editus_account.is_a?(ActiveRecord::Base)
      else
        session[:basic_auth_account]
      end
    end

    def request_account
      editus_auth_account.try(:email) || session[:basic_auth_account] || request.remote_ip
    end
  end
end
