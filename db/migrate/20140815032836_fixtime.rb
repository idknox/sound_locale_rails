class Fixtime < ActiveRecord::Migration
  def change
    remove_column :events, :date, :date
    remove_column :events, :time, :time
    add_column :events, :date_time, :datetime
  end
end
