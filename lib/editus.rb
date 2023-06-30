require_relative "editus/actions"
require_relative "editus/client"
require_relative "editus/cop"
require_relative "editus/definition_proxy"
require_relative "editus/engine"
require_relative "editus/file"
require_relative "editus/proxy"
require_relative "editus/script"
require_relative "editus/version"

module Editus
  class InvalidModelError < StandardError; end
  class UpdateFieldError < StandardError; end

  class Configuration
    CONFIG_PATH = "config/editus.yml"
    CONFIG_KEYS = %w[models auth actions_file_path]

    def initialize
      @table = {
        models: [],
        actions_file_path: "tmp/editus/actions.json"
      }
    end

    def [] name
      @table[name.to_sym]
    end

    def []= name, value
      name = name.to_sym
      @table[name] = value
    end

    private

    def respond_to_missing? mid, include_private = false
      mid[/.*(?==\z)/m].present? || super
    end

    def method_missing mid, *args
      len = args.length
      mname = mid[/.*(?==\z)/m]
      if mname
        if len != 1
          raise ArgumentError, "wrong number of arguments (given #{len}, expected 1)", caller(1)
        end

        @table[mname.to_sym] = args[0]
      elsif len.zero?
        @table[mid]
      else
        begin
          super
        rescue NoMethodError => e
          e.backtrace.shift
          raise
        end
      end
    end
  end

  class << self
    attr_writer :configuration
    attr_accessor :definition_file_paths
  end

  def self.configuration
    @configuration ||= Editus::Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  self.definition_file_paths = %w[config/editus]

  def self.find_definitions
    absolute_definition_file_paths = definition_file_paths.map{|path| File.expand_path(path)}

    absolute_definition_file_paths.uniq.each do |path|
      next unless File.directory? path

      Dir[File.join(path, "*.rb")].sort.each do |file|
        Editus::Script::Reader.read(file)
      end
    end
  end

  def self.load_file_config
    if File.exist?(Rails.root.join(Editus::Configuration::CONFIG_PATH))
      yaml = File.read(Rails.root.join(Editus::Configuration::CONFIG_PATH))
      config = YAML.safe_load(yaml)

      configure do |c|
        config.each do |key, value|
          next unless Editus::Configuration::CONFIG_KEYS.include?(key)

          c[key] = value
        end
      end
    else
      false
    end
  rescue StandardError
    false
  end
end
