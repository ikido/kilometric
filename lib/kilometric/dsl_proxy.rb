# this class is tightly coupled with KiloMetric::Config and and all
# it does is proxying dsl methods from directly affecting main class
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