class FixCol < ActiveRecord::Migration
  def change
    add_column :events, :headliner, :string
    remove_column :events, :headling, :string
  end
end
