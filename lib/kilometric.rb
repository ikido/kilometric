module KiloMetric

  # for testing purposes, generate redis prefix for all data pushed by KiloMetric,
  # based on namespace name
  def self.redis_prefix(namespace)
    "kilometric-#{namespace}"
  end

end

require "kilometric/version"
require "kilometric/defaults"
require "kilometric/api"
require "kilometric/dsl"
require "kilometric/event_manager"
require "kilometric/worker"
require "kilometric/config"
require "active_support/core_ext"
