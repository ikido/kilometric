#
# Api knows how to track events (write them to db backend) and how to load them back
# and return as a hash. It is intended to be used in a more hi-level situations, like
# a rails controller that returns json to a web client or in eventmachine loop that
# accepts incoming tcp connections with events
#
module Kilometric
  class API

    # track an event, we expect hash of event attributes
    def track_event(event_data)
      event_data = event_data.to_json
      push_event(event_data)
    end

    # retrieve values for a gauge within given period
    # options:
    #   * :gauge - name of the gauge
    #   * :from - start date, DD/MM/YY # TODO: accept date or time object
    #   * :to   - end date, DD/MM/YY # TODO: accept date or time object
    def fetch_gauge_values(options={})
    end

  private

    # connects to Redis and sets respective instance variable
    def connect
      @redis = Redis.connect(:url => @@opts[:redis_url])
    end

    def disconnect
      @redis.quit
    end

    # intialize api, merge passed options with defaults
    # and connect to Redis, if neede
    def initialize(options={})
      @options = DEFAULT_OPTIONS.merge(options)

      @namespace = @options.delete(:namespace)
      @redis = @options.delete(:redis)

      connect unless @redis
    end

    # default options, that can be overriden on initialization
    DEFAULT_OPTIONS = {
      :redis_url => "redis://localhost:6379",
      :redis_prefix => "kilometric",
      # event will be deleted and lost if not processed within
      # this number of seconds
      :event_queue_ttl => 120,
      :event_data_ttl => 3600*24*30
    }

    # generate random event id
    def get_next_uuid
      rand(8**32).to_s(36)
    end

    # actual method that adds event to redis, as well
    # as adding it to queue. It also sets ttl for an event
    def push_event(event_data)
      event_id = get_next_uuid
      prefix = @options[:redis_prefix]
      @redis.hincrby "#{prefix}-stats",             "events_received", 1
      @redis.set     "#{prefix}-event-#{event_id}", event_data
      @redis.lpush   "#{prefix}-queue",             event_id
      @redis.expire  "#{prefix}-event-#{event_id}", @options[:event_queue_ttl]
      event_id
    end

  end
end
