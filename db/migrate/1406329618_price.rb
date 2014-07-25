class Price < ActiveRecord::Migration
  def up
    remove_column :events, :price, :integer
    add_column :events, :price, :string

  end

  def down
    # add reverse migration code here
  end
end
