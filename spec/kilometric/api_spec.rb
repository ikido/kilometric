require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe KiloMetric::API do

  before(:all) do
    @now = Time.utc(1992,01,13,5,23,23).to_i
    @redis = Redis.new

    @opts = {
      :namespace => :test,
      :redis => @redis
    }

    @api = KiloMetric::API.new @opts
  end

  describe "initialize" do

    it "should properly init default options and override them with new options" do
      @api.options.redis.should == @redis
      @api.options.namespace.should == :test
      @api.options.redis_url.should == 'redis://localhost:6379'
      @api.options.event_queue_ttl.should == 120
      @api.options.event_data_ttl.should == 2592000
    end

  end

  describe "track_event" do

    before(:each) do
      @redis.keys("#{@api.redis_prefix}-*").each { |k| @redis.del(k) }
    end

    it "should create an event from a hash" do
      event_id = @api.track_event(
        :_type => "kil0234",
        :_time => @now
      )

      event = @api.fetch_event_data(event_id)
      expect(event['_type']).to eq("kil0234")
    end

    it "should add current timestamp if no _time option was passed"


  end

end