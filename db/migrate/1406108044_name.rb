class Name < ActiveRecord::Migration
  def change
    add_column :venues, :name, :string
  end

  def down
    # add reverse migration code here
  end
end
