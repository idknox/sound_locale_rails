class BaseConnector
  def get(path)
    uri = build_uri(path)
    response = HTTParty.get(uri)

    raise Exception if response.code != 200

    parsed_response = JSON.parse(response.body)
    Hashie::Mash.new(parsed_response)

  rescue Exception => e
    {path.to_sym => []}
  end
end