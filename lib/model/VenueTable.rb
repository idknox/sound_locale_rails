
class VenueTable

  def initialize(db)
    @db = db
  end

  def all
    @db.sql(
      "SELECT * FROM venues"
    )
  end
  
  def add_venue(venue)
    @db.sql(
      "INSERT INTO venues (name, title, site, position, background, " +
        "marker_name, address, size, description, price, map) " +
        "VALUES ('#{venue[:name]}', '#{venue[:title]}', '#{venue[:site]}', '#{venue[:position]}', " +
        "'#{venue[:background]}', '#{venue[:marker_name]}', " +
        "'#{venue[:address]}', '#{venue[:size]}', " +
        "'#{venue[:description]}', '#{venue[:price]}', '#{venue[:map]}')"
    )
  end

  def get_venue(id)
    @db.sql(
      "SELECT * FROM venues WHERE id =#{id}"
    )[0]
  end

  def update_venue(venue)
    @db.sql(
      "UPDATE venues set title='#{venue[:title]}', " +
        "position='#{venue[:position]}', background='#{venue[:background]}', " +
        "marker_name='#{venue[:marker_name]}', " +
        "address='#{venue[:address]}', size='#{venue[:size]}', " +
        "description='#{venue[:description]}', price='#{venue[:price]}', " +
        "map='#{venue[:map]}', logo='#{venue[:logo]}', site='#{venue[:site]}', " +
        "name='#{venue[:name]}' WHERE id=#{venue[:id]}"
    )
  end

  def delete_venue(id)
    @db.sql(
      "DELETE FROM venues WHERE id=#{id}"
    )
  end
end