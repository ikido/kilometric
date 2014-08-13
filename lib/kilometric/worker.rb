


module Kilometric
  class Worker

    # intialize api with namespace name
    def initialize(namespace = '')
    end

    # process next event in the queue and save respective gauge values
    # options:
    #   * callback — a block that will be called after event has been processed
    def process_next_event(callback = nil)
    end

  end
end
