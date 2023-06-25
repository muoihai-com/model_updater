require_dependency "model_updater/application_controller"

module ModelUpdater
  class HomeController < ApplicationController
    before_action :load_model, :load_record, :load_column

    def index
      @scripts = ModelUpdater::Script.all.values

      action = Struct.new(:type, :user, :script_id, :script_title, :model_name, :model_id, :changes)
      @actions = [
        action.new("manual", "example@gmail.com", nil, nil, "User", 1, {"name" => %w[bill bob]}),
        action.new("script", "example@gmail.com", 1, "Thay đổi deadline", nil, nil)
      ]
    end

    def validate
      @record.assign_attributes user_params
      @changes = @record.changes.transform_values{|(from, to)| "From #{from || 'null'} to #{to}"}
      @validate_error_flag = !@record.valid?
      @full_messages = @record.errors.full_messages

      render "validate"
    end

    def update
      @record.assign_attributes user_params
      action = ModelUpdater::Action.new
      action.changes = @record.changes
      action.type = "models"
      action.user = model_updater_account.try(:email) || request.ip
      action.model_id = @record.id
      action.model_name = @record.class.name
      action.save

      redirect_to root_path
    end

    def manual_update
      @model_names = ModelUpdater::Client.models
    end

    def scripts
      @scripts = ModelUpdater::Script.all.values
    end

    private

    def load_model
      return if params[:klass].blank?

      @proxy = ModelUpdater::Client.model(params[:klass])
      return if @proxy.blank?

      @column_names = @proxy.column_names
    end

    def load_record
      return if @proxy.blank? || params[:attribute].blank? || params[:value].blank?

      @record = @proxy.find_by(params[:attribute] => params[:value])
    end

    def load_column
      return if params[:column].blank? || @record.try(params[:column]).blank?

      @update_value = @record.try(params[:column])
    end

    def user_params
      params[:user].each_key{|key| params[:user].delete(key) if params[:user][key].blank?}
      params[:user].as_json
    end
  end
end
