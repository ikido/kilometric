require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe KiloMetric::DSL do

  before do
    @config = KiloMetric::Config.new
    @dsl = KiloMetric::DSL.new(@config)
    @file = File.read(::File.expand_path('../../fixtures/config.rb', __FILE__))
  end

  describe "load" do

    it "should read config DSL from file and override defaults in passed KiloMetric::Config instance" do
      @dsl.load(@file)

      expect(@config.namespace).to eq(:test)
      expect(@config.redis_url).to eq('redis://localhost:6379')

      expect(@config.gauges.first[:name]).to eq(:properties_live)
      expect(@config.gauges.first[:tick]).to eq(86400)

      expect(@config.gauges.second[:name]).to eq(:properties_added)
      expect(@config.gauges.second[:tick]).to eq(2592000)

      expect(@config.events.first[:name]).to eq(:set_total_properties_live)
      expect(@config.events.first[:block].kind_of?(Proc)).to eq(true)

      expect(@config.events.second[:name]).to eq(:property_added)
      expect(@config.events.second[:block].kind_of?(Proc)).to eq(true)
    end

    it "should read config DSL from a block and override defaults in passed KiloMetric::Config instance" do

      @dsl.load do
        redis_url 'redis://localhost:6380'
      end

      expect(@config.redis_url).to eq('redis://localhost:6380')

    end

  end

end
