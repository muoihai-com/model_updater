require_dependency 'model_updater/application_controller'

module ModelUpdater
  class HomeController < ApplicationController
    before_action :load_model, :load_record, :load_column

    def index
      @model_names = ModelUpdater::Diploma.models
    end

    def update
      @record.try(:update_column, params[:column], params[:update_value])

      @record.valid?
      flash[:record] = @record.inspect
      flash[:errors] = @record.errors.full_messages
      redirect_to root_path
    end

    private

    def load_model
      return if params[:klass].blank?

      model = ModelUpdater::Diploma.model(params[:klass])
      @proxy = ModelUpdater::Proxy.new(model)
      return if @proxy.blank?

      @column_names = @proxy.column_names - %w[id]
    end

    def load_record
      return if @proxy.blank? || params[:attribute].blank? || params[:value].blank?

      @record = @proxy.find_by(params[:attribute] => params[:value])
    end

    def load_column
      return if params[:column].blank? || @record.try(params[:column]).blank?

      @update_value = @record.try(params[:column])
    end
  end
end
