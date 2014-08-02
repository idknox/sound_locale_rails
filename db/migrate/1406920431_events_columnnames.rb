class EventsColumnnames < ActiveRecord::Migration
  def change
    rename_column :events, :tf_id, :vendor_id
    change_column :events, :date, :datetime
  end

  def down
    # add reverse migration code here
  end
end
