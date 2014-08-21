# Loads config from block or file via dsl, manages connection
# and exposes methods to read config and connection options
module KiloMetric
  class Config

    # this class will exist inside the KiloMetric::Config,
    # because it's tightly coupled with it and all it does is
    # proxying dsl methods from directly affecting main class
    class DslProxy

      def initialize(config)
        @config = config
      end

    private

      DSL_METHODS = [ :gauge, :event ]

      # we check if dsl methods are whitelisted or
      # listed as a config option (e.g. defaults hash include it)
      def method_missing(method, *args, &block)
        if KiloMetric::DEFAULTS.has_key?(method)
          set_config_option "@#{method}", args.first
        elsif DSL_METHODS.include?(method)
          send(method, *args, &block)
        else
          raise ArgumentError, "unknown config option: #{method}"
        end
      end

      def gauge(name, options={})
        push_to_config_option(:gauges, name: name, tick: options[:tick].to_i)
      end

      def event(name, &block)
        push_to_config_option(:events, name: name, block: block)
      end

      def set_config_option(name, value)
        @config.instance_variable_set name, value
      end

      def push_to_config_option(name = '', attributes = {})
        instance_var_name = "@#{name}"
        puts "instance_var_name: #{instance_var_name}"
        instance_var_value = @config.instance_variable_get(instance_var_name)
        puts "instance_var_value: #{instance_var_value.inspect}"

        instance_var_value.push attributes
        @config.instance_variable_set(instance_var_name, instance_var_value)
      end
    end

    # Note: anyone can write config options! this is probably not very good
    attr_reader :gauges, :events

    # enable reader accessors for attributes that have defaults
    KiloMetric::DEFAULTS.each do |key, value|
      attr_reader key.to_sym
    end

    def initialize(config_dsl = nil, &block)
      @gauges = []
      @events = []

      # load defauts
      KiloMetric::DEFAULTS.each do |option, value|
        instance_variable_set "@#{option}", value
      end

      @proxy = KiloMetric::DslProxy.new(self)
      if config_dsl
        @proxy.instance_eval(config_dsl)
      elsif block_given?
        @proxy.instance_eval(&block)
      end
    end

    # connects to Redis and sets respective instance variable
    def connect
      @connection ||= Redis.connect(url: @redis_url)
    end

    def redis_prefix
      "kilometric-#{@namespace}"
    end

    def disconnect
      @connection.quit
    end

    def connection
      @connection || connect
    end

  end
end