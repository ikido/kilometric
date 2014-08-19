# namespace name, to prefix keys in redis
namespace :test
redis_url "redis://localhost:6379"
event_queue_ttl 3600*24
event_data_ttl 3600*24

# gauge name and iterval
gauge :properties_live, tick: 1.day

gauge :properties_added, tick: 1.month

# event definition: name and block, that includes gauge modifications
event :set_total_properties_live do
  #set gauge's name
  set_value :properties_live, data[:total_properties_live]
end

event :property_added do
  # increase gauge by value
  incr :properties_added, 1
end
