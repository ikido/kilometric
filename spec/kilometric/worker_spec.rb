require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe KiloMetric::Worker do

  before(:all) do
    @now = Time.utc(1992,01,13,5,23,23).to_i
    @redis = Redis.new

    @namespace = "kilometric-test-namespace-api"

    @opts = {
      :namespace => @namespace,
      :redis_prefix => "kilometric-test",
      :redis => @redis
    }

    file = File.read(::File.expand_path('../../fixtures/config.rb', __FILE__))
    @worker = KiloMetric::Worker.new(file)
  end

  describe "track_event" do

    it "should read config DSL on initialize properly" do
      @worker.options.namespace.should == :test
      @worker.options.redis_url.should == 'redis://localhost:6380'

      @worker.gauges.first.name.should == :properties_live
      @worker.gauges.first.tick.should == 86400

      @worker.gauges.second.name.should == :properties_added
      @worker.gauges.second.tick.should == 2592000

      @worker.events.first.name.should == :set_total_properties_live
      @worker.events.first.block.kind_of?(Proc).should == true

      @worker.events.second.name.should == :property_added
      @worker.events.second.block.kind_of?(Proc).should == true
    end

  end

end