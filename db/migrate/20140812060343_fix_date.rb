class FixDate < ActiveRecord::Migration
  def change
    remove_column :events, :time, :datetime
    add_column :events, :date, :date
  end
end
