class Doors < ActiveRecord::Migration
  def change
    add_column :events, :doors, :time
  end
end
