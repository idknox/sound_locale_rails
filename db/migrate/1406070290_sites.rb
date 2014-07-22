class Sites < ActiveRecord::Migration
  def change
    add_column :venues, :site, :string
  end

  def down
    # add reverse migration code here
  end
end
