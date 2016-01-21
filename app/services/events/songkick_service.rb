module Events
  class SongkickService < Base

    attr_accessor :events

    def initialize(opts={})
      @opts = default_opts.merge(opts)
      @connector = SongkickConnector.new(@opts)
      @response = get(:events).resultsPage
    end

    def events
      total_pages = (@response.totalEntries / 100) + 1
      current_page = @response.page
      events = []

      until current_page > total_pages do
        @opts.merge!(page: current_page)

        raw_events = SongkickConnector.new(@opts).get(:events).resultsPage.results.event
        events += raw_events.map { |e| mapped_attributes(e) }
        current_page += 1
      end

      events
    end

    def event_count
      @response.meta.total
    end

    private

    def mapped_attributes(event)
      if venue(event).present?
        # headliner = event["series"]["displayName"] if event["series"]
        headliner = event["performance"].first.present? ? event["performance"][0]["artist"]["displayName"] : 'NA'

        {
          name: headliner,
          venue_id: Venue.find_by(name: event.venue.displayName).id,
          venue_name: event.venue.displayName,
          vendor_id: event.id.to_i,
          headliner: headliner,
          show_start: event.start.time.present? ? Time.zone.parse(event.start.date) : 'TBD',
          doors: '',
          tickets: '',
          url: event.uri,
          twitter: '',
          price: '',
          soundcloud_url: ''
        }
      else
        {venue_id: Random.rand(999999)}
      end
    end

    def venue(event)
      Venue.find_by(name: event.venue.title)
    end

    def default_opts
      {
        domain: 'api.songkick.com',
        version: '3.0',
        api_key: ENV['SONGKICK_KEY'],
        location: '6404',
        page: 1
      }
    end
  end
end