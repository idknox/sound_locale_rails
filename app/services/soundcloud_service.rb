class SoundcloudService
  def initialize
    @client = SoundCloud.new(client_id: ENV['SOUNDCLOUD_CLIENT_ID'])
  end

  def get_first_track(artist)
    tracks = @client.get("/tracks", q: artist, limit: 1)
    tracks.length > 0 ? tracks.first.permalink_url : ''
  end
end