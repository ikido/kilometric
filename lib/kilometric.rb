module KiloMetric

  # for testing purposes, generate redis prefix for all data pushed by KiloMetric,
  # based on namespace name
  def self.redis_prefix(namespace)
    "kilometric-#{namespace}"
  end

end

require "active_support/core_ext"
require "kilometric/api"
require "kilometric/defaults"
require "kilometric/config"
require "kilometric/event_manager"
require "kilometric/worker"
require "kilometric/version"