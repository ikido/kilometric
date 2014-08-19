require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe KiloMetric::Config do

  before do
    @config = KiloMetric::Config.new(namespace: :test)
  end

  describe "new" do

    it "should provide read/write accessor for each defalult config value" do
      config = KiloMetric::Config.new
      KiloMetric::DEFAULTS.each do |key, value|
        expect(config.send(key)).to eq(value)
        expect(config.respond_to?("#{key}=")).to eq(true)
      end

      expect(config.gauges).to eq([])
      expect(config.events).to eq([])
    end

    it "should override default with passed attributes" do
      expect(@config.namespace).to eq(:test)
    end

  end

  describe "redis_prefix" do

    it "should calculate redis prefix from namespace" do
      expect(@config.redis_prefix).to eq("kilometric-test")
    end

  end

  describe "connect" do
    before(:each) do
      @config = KiloMetric::Config.new
      @connection = double
      allow(Redis).to receive(:new).and_return(@connection)
    end

    it "should return new redis connection if not connected yet" do
      expect(@config.connect).to eq(@connection)
    end

    it "should return existing connection if already connected" do
      @config.connect

      @second_connection = double
      allow(Redis).to receive(:new).and_return(@second_connection)
      expect(@config.connect).to eq(@connection)
    end

  end

  describe "disconnect" do

    it "should close existing redis connection" do
      connection = double
      allow(Redis).to receive(:new).and_return(connection)
      config = KiloMetric::Config.new

      config.connect
      expect(connection).to receive(:quit)
      config.disconnect
    end

  end

  describe "connection" do

    it "should return existing connection" do
      connection = double
      allow(Redis).to receive(:new).and_return(connection)
      config = KiloMetric::Config.new

      config.connect
      expect(config.connection).to eq(connection)
    end

  end

end