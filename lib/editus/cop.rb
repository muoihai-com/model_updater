module Editus
  class Cop
    def self.instance
      @instance = new
    end

    def self.valid_model_names
      instance.valid_model_names
    end

    def initialize
      @models = Editus.configuration.models
      @mapping = @models.map{|model| get_values(model)}.compact
    end

    def valid_model_names
      @valid_model_names ||= @mapping.map{|m| m[:name]}
    end

    def info model
      result = if model.is_a?(String)
        @mapping.find{|x| x[:name] == model}
      elsif model.respond_to?(:name)
        @mapping.find{|x| x[:name] == model.name}
      end

      result || {}
    end

    private

    def get_values model
      return nil if model.blank?
      return nil unless model.is_a?(String) || model.is_a?(Hash)

      name = model.is_a?(String) ? model : model[:name]
      fields = model.is_a?(Hash) ? model[:fields] : []
      exclude_fields = model.is_a?(Hash) ? model[:exclude_fields] : []

      {name: name, fields: fields, exclude_fields: exclude_fields}
    end
  end
end
