#
# Api knows how to track events (write them to db backend) and how to load them back
# and return as a hash. It is intended to be used in a more hi-level situations, like
# a rails controller that returns json to a web client or in eventmachine loop that
# accepts incoming tcp connections with events
#
# Usage: @api = KiloMetric::API.new do
#   namespace: :some_name
#   redis_url: "redis://localhost:6379"
# end
#
# @api.track(_type: "kil0234", _time: Time.now)
# @api.fetch(gauges: [:properties_live], from: 1.week.ago, to: Time.now)
# @api.start_worker
# @api.stop_worker
#
# TODO: @api.workoff, process all events currently in the queue and ext
#
module KiloMetric
  class API

    attr_reader :config

    # intialize api, merge passed options with defaults
    # and connect to Redis, if neede
    def initialize(config_dsl = nil, &block)
      @config = KiloMetric::Config.new

      # load config from passed file or block
      if config_dsl or block_given?
        dsl = KiloMetric::DSL.new(@config)

        if config_dsl
          dsl.load(config_dsl)
        elsif block_given?
          dsl.load(&block)
        end
      end

      @config.connect
      @event_manager = KiloMetric::EventManager.new(@config)
    end


    # track an event, we expect hash of event attributes
    # TODO: add current timestamp if no _type option was passed
    def track(event_data)
      @event_manager.track(event_data)
    end

    # retrieve values for a gauge within given period
    # options:
    #   * :gauge - name of the gauge
    #   * :from - start date, DD/MM/YY # TODO: accept date or time object
    #   * :to   - end date, DD/MM/YY # TODO: accept date or time object
    #
    # TODO: allow to fetch data from multiple gauges
    #
    def fetch(options={})
      @event_manager.fetch(options)
    end

    def workoff
    end

    # def start_worker
    # end

    # def stop_worker
    # end

  end
end
