module KiloMetric
  class EventManager

    def initialize(config)
      @config = config
    end


    def fetch(event_id)
      namespace = @config.namespace

      redis_key = [redis_prefix, :event, event_id].join("-")
      json = redis.get(redis_key) || "{}"
      JSON.parse(json)
    end

    def track(event_data)
    end

    def redis
      @config.redis
    end

    def redis_prefix
      @config.redis_prefix
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