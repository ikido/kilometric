module KiloMetric

  DEFAULTS = OpenStruct.new(
    redis_url: "redis://localhost:6379",
    namespace: :default,
    event_queue_ttl: 120,
    event_data_ttl: 3600*24*30
  )

end