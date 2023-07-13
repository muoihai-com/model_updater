require_dependency "editus/application_controller"

module Editus
  class HomeController < ApplicationController
    before_action :load_model, :load_record, :load_column

    def index
      @scripts = Editus::Script.all.values
      @actions = Editus::Actions.all.reverse
    end

    def validate
      @record.assign_attributes user_params
      @changes = @record.changes.transform_values do |(from, to)|
        "From #{from.nil? ? 'null' : from} to #{to}"
      end
      @validate_error_flag = !@record.valid?
      @full_messages = @record.errors.full_messages

      render "validate"
    end

    def update
      @record.assign_attributes user_params
      return redirect_to(root_path) unless @record.changed?

      action = Editus::Action.new
      action.changes = @record.changes
      action.type = "models"
      action.user = request_account
      action.model_id = @record.id
      action.model_name = @record.klass.class.name
      action.save
      @record.update_columns user_params

      redirect_to root_path
    end

    def manual_update
      @model_names = Editus::Client.models
    end

    def scripts
      @scripts = Editus::Script.all.values
    end

    def run_script
      script = Editus::Script.all[params[:id].to_sym]
      return redirect_to(root_path) if script.blank?

      action = Editus::Action.new
      action.type = "scripts"
      action.user = request_account
      action.model_id = script.name
      action.model_name = script.title
      action.changes = script.proxy.up(*parameters) if script.proxy.respond_to?(:up)
      action.save

      redirect_to root_path
    end

    def query
      script = Editus::Script.all[params[:id].to_sym]
      method = params[:method].to_sym
      return render json: {status: false, error: :script_not_found}, status: 200 if script.blank?

      unless script.proxy.respond_to?(method)
        return render json: {status: false, error: :undefined_method},
                      status: 200
      end

      result = script.proxy.try(method, *parameters)
      render json: {status: true, data: result}, status: 200
    end

    def undo
      action = Editus::Actions.all.find{|act| act.id == params[:id]}
      return redirect_to(root_path) if action.blank?

      new_action = Editus::Action.new
      new_action.type = "undo"
      new_action.user = request_account
      new_action.model_id = action.id
      new_action.model_name = action.model_name
      case action.type
      when "models"
        pr = action.changes.transform_values{|(from, _to)| from}
        record = action.model_name.constantize.find(action.model_id)
        record.assign_attributes pr
        new_action.changes = record.changes
        record.update_columns pr
      when "scripts"
        script = Editus::Script.all[action.model_id.to_sym]
        return redirect_to(root_path) if action.blank?

        if script.proxy.respond_to?(:down)
          action.changes.empty? ? script.proxy.down : script.proxy.down(*action.changes)
        end
      end
      new_action.save

      redirect_to root_path
    end

    private

    def load_model
      return if params[:klass].blank?

      @proxy = Editus::Client.model(params[:klass])
      return if @proxy.blank?

      @column_names = @proxy.column_names
    rescue NameError
      redirect_to manual_update_path
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
      params[:user]&.each{|key, _| params[:user].delete(key) if params[:user][key].blank?}
      (params[:user] || {}).as_json
    end

    def parameters
      params[:parameters]&.values || []
    end
  end
end
