# EventManager.track(event_data)

module KiloMetric
  class EventManager

    def initialize(config)
      @connection = config.connection
      @redis_prefix = config.redis_prefix
      @event_queue_ttl = config.event_queue_ttl
    end

    def fetch(event_id)
      key = redis_key(event_id)
      json = @connection.get(key) || "{}"
      JSON.parse(json)
    end

    def track(event_data)
      event_id = get_next_uuid
      key = redis_key(event_id)

      @connection.hincrby "#{redis_prefix}-stats", "events_received", 1
      @connection.set     key, event_data
      @connection.lpush   "#{redis_prefix}-queue", event_id
      @connection.expire  key, @event_queue_ttl

      event_id
    end

  private

    # generate random event id, TODO: make this id unique, e.g. based on timestamp
    def get_next_uuid
      rand(8**32).to_s(36)
    end

    # generate redis key for event data, based on event id and redis prefix
    def reids_key(event_id)
      "#{redis_prefix}-event-#{event_id}"
    end

  end
end