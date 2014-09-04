class ChngDate < ActiveRecord::Migration
  def change
    remove_column :events, :date, :datetime
    add_column :events, :date, :date
  end
end
