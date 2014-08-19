module KiloMetric
  class DSL

    def initialize(config)
      @config = config
    end

    def load(config_dsl = nil, &block)
      if config_dsl
        self.instance_eval(config_dsl)
      elsif block_given?
        self.instance_eval(&block)
      end
    end

    def gauge(name, options={})
      @config.gauges.push( name: name, tick: options[:tick].to_i )
    end

    def event(name, &block)
      @config.events.push( name: name, block: block )
    end

    def method_missing(method, *args, &block)
      if KiloMetric::DEFAULTS.has_key?(method) and @config.respond_to?("#{method}=")
        @config.send("#{method}=", args.first)
      else
        raise ArgumentError, "unknown config option: #{method}"
      end
    end

  end
end