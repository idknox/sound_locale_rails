class AxsConnector < BaseConnector
  attr_reader :opts

  def initialize(opts={})
    @opts = opts
  end

  def build_uri(path)
    "http://#{opts[:domain]}/#{opts[:version]}/#{path}?access_token=#{opts[:access_token]}&siteId=1&rows=500&lat=#{opts[:lat]}&long=#{opts[:long]}&radius=#{opts[:radius]}"
  end
end