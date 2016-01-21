class SongkickConnector < BaseConnector
  attr_reader :opts

  def initialize(opts={})
    @opts = opts
  end

  def build_uri(path)
    "http://#{opts[:domain]}/api/#{opts[:version]}/#{path}.json?apikey=#{opts[:api_key]}&location=sk:#{opts[:location]}&per_page=100&page=#{opts[:page]}"
  end
end