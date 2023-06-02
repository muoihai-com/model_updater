require_dependency "model_updater/application_controller"

module ModelUpdater
  class HomeController < ApplicationController
    before_action :load_model, :load_record, :load_column

    def index
      @model_names = ModelUpdater::Diploma.models
    end

    def update
      @record.assign_attributes user_params
      @changes = @record.changes
      @validate_error_flag = @record.valid?
      @full_messages = @record.errors.full_messages

      render "update"
    end

    def manual_update
      @model_names = ModelUpdater::Diploma.models
    end

    def scripts; end

    private

    def load_model
      return if params[:klass].blank?

      @proxy = ModelUpdater::Diploma.model(params[:klass])
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
