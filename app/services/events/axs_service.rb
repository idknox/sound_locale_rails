module Events
  class AxsService < Base

    attr_accessor :events

    def initialize(opts={})
      opts = default_opts.merge(opts)
      @connector = AxsConnector.new(opts)
      @events = get(:events).events.map { |e| mapped_attributes(e) }
    end

    def event_count
      @response.meta.total
    end

    private

    def get(path)
      @response ||= @connector.get(path)
    end

    def mapped_attributes(event)
      if venue(event).present?
        {
          name: event.title.eventTitleText,
          venue_id: venue(event).id,
          venue_name: event.venue.title,
          vendor_id: event.eventId.to_i,
          headliner: event.title.eventTitleText,
          opener: event.title.supportingText,
          show_start: Time.zone.parse(event.eventDateTime),
          doors: '',
          tickets: event.ticketing.url,
          url: event.ticketing.eventUrl,
          twitter: "",
          advance_price: event.ticketPrice,
          door_price: event.doorPrice,
          soundcloud_url: ''
        }
      else
        {venue_id: Random.rand(999999)}
      end
    end

    def venue(event)
      Venue.find_by(name: event.venue.title)
    end

    def price_breakout(ticket)
      "#{ticket.ticketPrice} advance / #{ticket['doorPrice']} door"
    end

    def default_opts
      {
        domain: 'api.axs.com',
        version: 'v1',
        access_token: ENV['AXS_KEY'],
        lat: 39.740009,
        long: -104.992302,
        radius: 100
      }
    end

  end
end