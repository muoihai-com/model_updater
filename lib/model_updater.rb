require_relative "model_updater/actions"
require_relative "model_updater/client"
require_relative "model_updater/definition_proxy"
require_relative "model_updater/engine"
require_relative "model_updater/file"
require_relative "model_updater/proxy"
require_relative "model_updater/script"
require_relative "model_updater/version"

module ModelUpdater
  class InvalidModel < StandardError; end

  class Configuration
    def initialize
      @table = {
        auth: false,
        actions_file_path: "tmp/model_updaters/actions.yml"
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

    def respond_to_missing? mid
      mid[/.*(?==\z)/m].present? || @table.key?(mid.to_sym)
    end

    def method_missing(mid, *args)
      len = args.length
      mname = mid[/.*(?==\z)/m]
      if mname
        if len != 1
          raise ArgumentError, "wrong number of arguments (given #{len}, expected 1)", caller(1)
        end

        @table[mname.to_sym] = args[0]
      elsif len.zero? && @table.key?(mid.to_sym)
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
    @configuration ||= ModelUpdater::Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  self.definition_file_paths = %w[config/model_updaters]

  def self.find_definitions
    absolute_definition_file_paths = definition_file_paths.map{|path| File.expand_path(path)}

    absolute_definition_file_paths.uniq.each do |path|
      next unless File.directory? path

      Dir[File.join(path, "*.rb")].sort.each do |file|
        ModelUpdater::Script::Reader.read(file)
      end
    end
  end
end
