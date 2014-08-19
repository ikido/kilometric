# Usage: dispatcher = KiloMetric::Dispatcher.new(config_dsl)
#        dispatcher.start
#        dispatcher.stop

module KiloMetric
  class Dispatcher
    include Celluloid
    attr_reader :config
    trap_exit :handle_worker_exit


    def start
      @worker = KiloMetric::Worker.new_link(@config)
      @worker.start
    end

    def stop
      @worker.quit
    end

  private

    # intialize api with config dsl — someting that can be a file or a string
    # it will be passed to KiloMetric::Configuration#initialize, who in turn
    # will process DSL and expose configuration
    def initialize(config_dsl)
      @config = KiloMetric::Config.parse(config_dsl)
    end

    def handle_worker_exit

    end

  end
end
