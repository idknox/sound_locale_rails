class Fixdate < ActiveRecord::Migration
  def change
    remove_column :events, :date_time, :datetime
    add_column :events, :date, :datetime
    add_column :events, :time, :time
  end
end
