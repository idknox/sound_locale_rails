class AddPricesToEvent < ActiveRecord::Migration
  def change
    add_column :events, :advance_price, :string
    add_column :events, :door_price, :string
    add_column :events, :show_start, :time
    change_column :events, :doors, :time
    remove_column :events, :date
    remove_column :events, :time
    remove_column :events, :price
  end
end
