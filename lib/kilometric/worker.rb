# Usage: worker = KiloMetric::Worker.new(config_dsl)
#        worker.start
#        worker.stop

# TODO:
# - worker should start async worker
# - worker should start new worker when one dies
# - worker should stop the worker

module KiloMetric
  class Worker
    include Celluloid
    attr_reader :config
    trap_exit :handle_worker_exit


    def start
      @processor = KiloMetric::Processor.new_link(@config)
      @processor.start!
    end

    def stop
      @processor.quit
    end

  private

    # intialize api with config dsl — someting that can be a file or a string
    # it will be passed to KiloMetric::Configuration#initialize, who in turn
    # will process DSL and expose configuration
    def initialize(config_dsl = nil)
      @config = KiloMetric::Config.parse(config_dsl)
    end

    # Restart dead worker. This method is more like a placeholder, more
    # logic will be here later
    def handle_worker_exit(worker, reason)
      start
      # this should take worker's job from processing queue and reprocess it,
      # then launch another worker
    end

  end
end
