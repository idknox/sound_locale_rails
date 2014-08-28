class Location < ActiveRecord::Migration
  def change
    remove_column :venues, :position, :string
    add_column :venues, :location, :string
  end
end
