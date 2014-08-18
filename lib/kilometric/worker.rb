# Usage: worker = KiloMetric::Worker.new(config_dsl)
#        worker.start
#        worker.stop

module KiloMetric
  class Worker

    attr_reader :options, :gauges, :events

    def start(callback = nil)
    end

    def stop
    end

  private

    DEFAULT_OPTIONS = OpenStruct.new(
      redis_url: "redis://localhost:6379", # redis url to connect to
      namespace: :default
    )

    # intialize api with config dsl — someting that can be a file or a string
    def initialize(config_dsl)
      @gauges = []
      @events = []
      @options = DEFAULT_OPTIONS.dup

      self.instance_eval(config_dsl)
      # call config ruby file, with instance_eval
      # delegate event and gauge method with method_missing (maybe use Proxy class)
    end

    def redis_url(value)
      @options.redis_url = value
    end

    def namespace(value)
      @options.namespace = value
    end

    def gauge(name, options={})
      @gauges.push OpenStruct.new(name: name, tick: options[:tick].to_i)
    end

    def event(name, &block)
      @events.push OpenStruct.new(name: name, block: block)
    end

  end
end
