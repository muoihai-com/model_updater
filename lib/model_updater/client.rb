module ModelUpdater
  class Client
    class << self
      def models
        ::ApplicationRecord.descendants.map(&:name)
      end

      def model name
        klass = Object.const_get(name)

        ModelUpdater::Proxy.new(klass)
      end
    end
  end
end
