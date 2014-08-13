#
# Api knows how to track events (write them to db backend) and how to load them back
# and return as a hash. It is intended to be used in a more hi-level situations, like
# a rails controller that returns json to a web client or in eventmachine loop that
# accepts incoming tcp connections with events
#
module Kilometric
  class Api

    # intialize api with namespace name
    def initialize(namespace = '')
    end

    # track an event
    def track_event(options={})
    end

    # retrieve values for a gauge within given period
    # options:
    #   * :gauge - name of the gauge
    #   * :from - start date, DD/MM/YY # TODO: accept date or time object
    #   * :to   - end date, DD/MM/YY # TODO: accept date or time object
    def fetch_gauge_values(options={})
    end

  end
end
