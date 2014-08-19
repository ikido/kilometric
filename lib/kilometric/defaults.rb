module KiloMetric

  # Just a structure that holds all available defaults
  # We use Openstruct just for a bit cleaner code
  DEFAULTS = {
    redis_url: "redis://localhost:6380",
    namespace: :default,
    event_queue_ttl: 3600*24,
    event_data_ttl: 3600*24
  }

end