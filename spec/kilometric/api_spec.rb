require ::File.expand_path('../../spec_helper.rb', __FILE__)

describe Kilometric::API do

  before(:all) do
    @now = Time.utc(1992,01,13,5,23,23).to_i
    @redis = Redis.new

    @namespace = "kilometric-test-namespace-api"

    @opts = {
      :namespace => @namespace,
      :redis_prefix => "kilometric-test",
      :redis => @redis
    }

    @api = Kilometric::API.new @opts
  end

  describe "track_event" do

    before(:each) do
      @redis.keys("kilometric-test-*").each { |k| @redis.del(k) }
    end

    it "should create an event from a hash" do
      event_id = @api.track_event(
        :_type => "kil0234",
        :_time => @now
      )

      event = fetch_event_data(event_id)
      expect(event['_type']).to eq("kil0234")
    end


  end

  def fetch_event_data(event_id)
    redis_key = [@opts[:redis_prefix], :event, event_id].join("-")
    json = @opts[:redis].get(redis_key) || "{}"
    JSON.parse(json)
  end

end