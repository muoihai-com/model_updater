module Editus
  module Script
    class << self
      def define name, &block
        Editus::Script::DSL.run(name, &block)
      end

      def all
        Editus::Script::Internal.scripts
      end
    end

    class Internal
      @scripts = {}

      class << self
        attr_reader :scripts
      end

      def self.find_or_create name
        @scripts[name.to_sym] || @scripts[name.to_sym] = new(name.to_sym)
      end

      attr_accessor :name, :title, :path, :proxy, :content

      def initialize name = nil
        @name = name
      end

      def up
        content[/task\s.*up.*do.*\n[\s\S]*?\n\s*end/]
      end

      def down
        content[/task\s.*down.*do.*\n[\s\S]*?\n\s*end/]
      end
    end

    class DSL
      TASKS = %w[up down].freeze

      def self.run name, &block
        new(name).instance_eval(&block)
      end

      def initialize name
        @name = name
      end

      def task method, &block
        return unless TASKS.include?(method.to_s)

        internal = Internal.find_or_create @name
        internal.proxy ||= Editus::DefinitionProxy.new(@name)
        internal.proxy.define_singleton_method(method, &block)
      end

      def title txt
        internal = Internal.find_or_create @name
        internal.title = txt
      end
    end

    class Reader
      def self.read path
        return unless File.exist?(path)

        load(path)
        filename = File.basename(path, ".rb")
        internal = Internal.find_or_create filename
        internal.content = File.read(path)
        internal.path = path
        true
      end
    end
  end
end
