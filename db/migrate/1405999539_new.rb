class New < ActiveRecord::Migration
  def change
    add_column :venues, :background, :string
  end
end
