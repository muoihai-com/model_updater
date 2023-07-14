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

      attr_accessor :name, :path, :proxy, :content, :queries
      attr_writer :title

      def initialize name = nil
        @name = name
        @queries = []
      end

      def add_query desc, name
        @queries.push({description: desc, query_name: name})
      end

      def up
        content[/task\s.*up.*do.*\n[\s\S]*?\n\s*end/]
      end

      def down
        content[/task\s.*down.*do.*\n[\s\S]*?\n\s*end/]
      end

      def title
        @title || @name.to_s.humanize
      end
    end

    class DSL
      TASKS = %w[up down].freeze

      def self.run name, &block
        new(name).instance_eval(&block)
      end

      def initialize name
        @name = name
        @query_index = 0
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

      def desc description
        @description = if description.blank? || !description.is_a?(String)
          @query_index += 1
          "Query##{@query_index}"
        else
          description
        end
      end

      def query method, &block
        internal = Internal.find_or_create @name
        internal.proxy ||= Editus::DefinitionProxy.new(@name)
        query_name = "query_#{method}"
        internal.proxy.define_singleton_method(query_name, &block)
        add_query_to_internal internal, query_name
      end

      private

      def add_query_to_internal internal, query_name
        description = desc(@description)
        internal.add_query description, query_name
        @description = nil
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
