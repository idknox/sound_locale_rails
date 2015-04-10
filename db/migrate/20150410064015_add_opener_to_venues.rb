class AddOpenerToVenues < ActiveRecord::Migration
  def change
    add_column :events, :opener, :string
  end
end
