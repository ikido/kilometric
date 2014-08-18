#
# Api knows how to track events (write them to db backend) and how to load them back
# and return as a hash. It is intended to be used in a more hi-level situations, like
# a rails controller that returns json to a web client or in eventmachine loop that
# accepts incoming tcp connections with events
#
# Usage: @api = KiloMetric::API.new(namespace: :some_name, redis_url: "redis://localhost:6379")
#        @api.track_event(_type: "kil0234", _time: Time.now)
#        @api.fetch_gauge_values(gauge: :properties_live, from: 1.week.ago, to: Time.now)
#
module KiloMetric
  class API

    attr_reader :options

    # track an event, we expect hash of event attributes
    # TODO: add current timestamp if no _type option was passed
    def track_event(event_data)
      event_data = event_data.to_json
      push_event(event_data)
    end

    # retrieve values for a gauge within given period
    # options:
    #   * :gauge - name of the gauge
    #   * :from - start date, DD/MM/YY # TODO: accept date or time object
    #   * :to   - end date, DD/MM/YY # TODO: accept date or time object
    #
    # TODO: allow to fetch data from multiple gauges
    #
    def fetch_gauge_values(options={})
    end

    # for testing purposes, generate redis prefix for all data pushed by KiloMetric,
    # based on namespace name
    def redis_prefix
      "kilometric-#{@options.namespace}"
    end

    # for testing purposes, fetches raw event data from redis
    def fetch_event_data(event_id)
      redis_key = [redis_prefix, :event, event_id].join("-")
      json = @redis.get(redis_key) || "{}"
      JSON.parse(json)
    end

  private

    # default options, that can be overriden on initialization
    DEFAULT_OPTIONS = OpenStruct.new(
      # redis connection instance, if nil then try to connect to redis url
      redis: nil,

      # namespace symbolic name — string or symbol, wil be used also as a prefix
      # for namespace-specific reids keys
      namespace: :default,

      # redis url to connect to
      redis_url: "redis://localhost:6379",

      # event will be deleted and lost if not processed within
      # this number of seconds
      event_queue_ttl: 120,

      # event data will be deleted after this number of seconds expire
      event_data_ttl: 3600*24*30
    )

    # connects to Redis and sets respective instance variable
    def connect
      @redis = Redis.connect(:url => @options.redis_url)
    end

    def disconnect
      @redis.quit
    end

    # intialize api, merge passed options with defaults
    # and connect to Redis, if neede
    def initialize(options={})
      @options = DEFAULT_OPTIONS
      options.each do |key, value|
        @options.send("#{key}=", value) unless value.blank?
      end

      @redis = @options.redis

      connect unless @redis
    end

    # generate random event id
    def get_next_uuid
      rand(8**32).to_s(36)
    end

    # generate redis key for event data, based on event id and redis prefix
    def event_data_redis_key(event_id)
      "#{redis_prefix}-event-#{event_id}"
    end

    # actual method that adds event to redis, as well
    # as adding it to queue. It also sets ttl for an event
    def push_event(event_data)
      event_id = get_next_uuid
      @redis.hincrby "#{redis_prefix}-stats",             "events_received", 1
      @redis.set     event_data_redis_key(event_id), event_data
      @redis.lpush   "#{redis_prefix}-queue",             event_id
      @redis.expire  "#{redis_prefix}-event-#{event_id}", @options.event_queue_ttl
      event_id
    end

  end
end
