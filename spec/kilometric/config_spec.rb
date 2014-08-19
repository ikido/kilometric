require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe KiloMetric::Dispatcher do

  before(:all) do
    file = File.read(::File.expand_path('../../fixtures/config.rb', __FILE__))
    @config = KiloMetric::Config.parse(file)
  end

  describe "new" do

    it "should read config DSL and override defaults" do
      @config.namespace.should == :test
      @config.redis_url.should == 'redis://localhost:6380'

      @config.gauges.first.name.should == :properties_live
      @config.gauges.first.tick.should == 86400

      @config.gauges.second.name.should == :properties_added
      @config.gauges.second.tick.should == 2592000

      @config.events.first.name.should == :set_total_properties_live
      @config.events.first.block.kind_of?(Proc).should == true

      @config.events.second.name.should == :property_added
      @config.events.second.block.kind_of?(Proc).should == true
    end

  end

end