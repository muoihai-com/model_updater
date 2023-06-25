module ModelUpdater
  class ApplicationController < ActionController::Base
    include ::ApplicationHelper

    before_action :authenticate!

    def authenticate!
      return unless ModelUpdater.configuration.auth
      return if defined?(model_updater_account) && model_updater_account.present?

      head 401
    end
  end
end
