require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe KiloMetric::Dispatcher do

  before(:all) do
    @file = File.read(::File.expand_path('../../fixtures/config.rb', __FILE__))
    @dispatcher = KiloMetric::Dispatcher.new(@file)
  end

  describe "new" do

    it "should supply passed file as an argument to KiloMetric::Config#parse" do
      KiloMetric::Config.should_receive(:parse).with(@file)
      KiloMetric::Dispatcher.new(@file)
    end

    it "should expose config returned by KiloMetric::Config#new" do
      config = double
      KiloMetric::Config.stub(:parse).and_return(config)
      dispatcher = KiloMetric::Dispatcher.new(@file)
      dispatcher.config.should == config
    end

  end

end