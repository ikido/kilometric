# KiloMetric

Simple, modular redis/ruby-based event tracking heavily inspired by _Fnordmetric_.

Roadmap to version 0.1:

- ~~API method that adds events to Redis Queue, with event key, timestamp and value~~

- Background worker that processes events, it should wait for incoming events and process them. It should be possible to start/stop worker from command line, as well as from ruby code. Worker should read DSL-based ruby script in current folder for configuration

- API method that when given a name of gauge (or several gauge names, as array) and optionally a start and end date it should return a hash sorted by tick time, where tick timestamp is a key, and gauge value is a value.

- Multiple concurrent workers with Celluloid, processing events

Possible future features:

- Eventmachine/Celluloid-based Web API to recieve events by HTTP as JSON, and return gauge values also as JSON by HTTP.

- Sinatra app that will show available stats in a nice UI, with d3.js-based charts and graphs

- Rails integration gem, that uses ActiveRecord and MySQL/Postgres to store/retrieve data

---

Worker specs

- when started, it starts infinite loop to process events
- should be possible to start in background
- when you close one, it should catch an exception, finish processing current event and then exit
- later on, it should start running in a background with a bin command, write pid somewhere on the system,
  and the close itself when bin is started with close command, like:

  kilometric start
  kilometric stop

- after that we should employ multithreading, so that processing of reach event happens on a separate thread

TODO:

- EventManager, Worker and their specs
- Add current timestamp if no _type option was passed to KiloMetric::API#event
- Allow to fetch data from multiple gauges with KiloMetric::API#fetch_gauge_values
- Use BRPOPLPUSH instead of BLPOP for more durable message processing in KiloMetric::Worker, e.g. not to loose events

Requirements:

- Ruby 1.9.3, due to Celluloid it is preferred to use Rubini.us or Jruby interpreters instead of vanilla MRI/ 