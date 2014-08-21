require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe KiloMetric::API do

  before do
    @file = File.read(::File.expand_path('../../fixtures/config.rb', __FILE__))
    @config = KiloMetric::Config.new
  end

  describe "initialize" do

    it "should load default config if no options passed" do
      api = KiloMetric::API.new

      KiloMetric::DEFAULTS.each do |key, value|
        expect(api.config.send(key)).to eq(value)
      end

      expect(api.config.gauges).to eq([])
      expect(api.config.events).to eq([])
    end

    it "should load config from file and override values" do
      api = KiloMetric::API.new(@file)

      expect(api.config.namespace).to eq(:test)
      expect(api.config.redis_url).to eq('redis://localhost:6379')

      expect(api.config.gauges.first[:name]).to eq(:properties_live)
      expect(api.config.gauges.first[:tick]).to eq(86400)

      expect(api.config.gauges.second[:name]).to eq(:properties_added)
      expect(api.config.gauges.second[:tick]).to eq(2592000)

      expect(api.config.events.first[:name]).to eq(:set_total_properties_live)
      expect(api.config.events.first[:block].kind_of?(Proc)).to eq(true)

      expect(api.config.events.second[:name]).to eq(:property_added)
      expect(api.config.events.second[:block].kind_of?(Proc)).to eq(true)
    end

    it "should load config from block and override values" do
      url = 'redis://localhost:6380'

      api = KiloMetric::API.new do
        redis_url url
      end

      expect(api.config.redis_url).to eq(url)
    end

  end

  describe "config" do
    it "should return instance of KiloMetric::Config" do
      expect(KiloMetric::Config).to receive(:new).and_return(@config)
      api = KiloMetric::API.new
      api.config
    end
  end

  describe "track" do

    it "should delegate method to KiloMetric::EventManager#track" do
      event_manager = double
      allow(event_manager).to receive(:connection)

      allow(KiloMetric::EventManager).to receive(:new).and_return(event_manager)
      api = KiloMetric::API.new
      args = { foo: 'bar' }
      event_id = 123456
      expect(event_manager).to receive(:track).with(args).and_return(event_id)
      expect(api.track(args)).to eq(event_id)
    end

  end

end