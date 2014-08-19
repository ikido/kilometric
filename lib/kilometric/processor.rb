# TODO:
# - processor should fetch last event, and maybe just puts it console or logfile
# - processor should start and wait for new messages on the queue
# - processor should stop waiting for next event on the queue

module KiloMetric
  class Processor

    def initalize(config)
      @config = config || KiloMetric::Config
    end

    def start
      # TODO: use BRPOPLPUSH instead of BLPOP for more durable message processing
      # http://stackoverflow.com/a/13672601/1657839
    end

    def stop
    end

  private

  end
end