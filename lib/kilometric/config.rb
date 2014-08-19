module KiloMetric
  class Config

    # Note: anyone can write config options! this is probably not very good
    attr_accessor :gauges, :events

    # enable accessors for attributes that have defaults
    KiloMetric::DEFAULTS.each do |key, value|
      attr_accessor key.to_sym
    end

    def initialize(options = {})
      self.gauges = []
      self.events = []

      # load defauts and override them with passed options
      KiloMetric::DEFAULTS.each do |key, value|
        value = options[key] unless options[key].blank?
        send "#{key}=", value
      end
    end

    # connects to Redis and sets respective instance variable
    def connect
      @connection ||= Redis.connect(url: redis_url)
    end

    def redis_prefix
      "kilometric-#{@namespace}"
    end

    def disconnect
      connection.quit
    end

    def connection
      @connection || connect
    end

  end
end