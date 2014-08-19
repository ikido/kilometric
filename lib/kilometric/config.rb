module KiloMetric
  class Config

    class << self

      # TODO: move defaults somewhere
      def parse(config_dsl)

        @@config = OpenStruct.new(
          redis_url: KiloMetric::DEFAULTS.redis_url, # redis url to connect to
          namespace: KiloMetric::DEFAULTS.namespace,
          gauges: [],
          events: []
        )

        self.class_eval(config_dsl)
        return @@config
      end


    # Private class methods invoked by DSL
    private

      # TODO: Add method_missing to catch non-existent DSL verbs

      def redis_url(value)
        @@config.redis_url = value
      end

      def namespace(value)
        @@config.namespace = value
      end

      def gauge(name, options={})
        @@config.gauges.push OpenStruct.new(name: name, tick: options[:tick].to_i)
      end

      def event(name, &block)
        @@config.events.push OpenStruct.new(name: name, block: block)
      end

    end

  end
end