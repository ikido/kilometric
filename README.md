# Kilometric

Simple, modular redis/ruby-based event tracking heavily inspired by _Fnordmetric_.

Roadmap to version 0.1:

- API that adds events to Redis Queue, with event key, timestamp and value

- DSL that allows simple definition of events and gauges, similar to _Fnordmetric_. Two types of gauges will be supported in the beginning: _incr_ and _set_value_

- Worker that processes events, it should be possible to do the following:
 - process next event in the queue
 - start/stop a loop to wait for incoming events (via redis.blopop) and process them
 - rake that starts/stops background worker, which waits for incoming events and processes them

Possible future features:

- When given a name of gauge (or several gauge names, as array) and optionall y a start and end date it should return a hash sorted by tick time, where tick timestamp is a key, and gauge value is a value.

- Eventmachine/Cellulose-based Web API to recieve events by HTTP as JSON, and return gauge values also as JSON by HTTP.

- Sinatra app that will show available stats in a nice UI

- Rails integration gem, that uses ActiveRecord and MySQL/Postgres to store/retrieve data