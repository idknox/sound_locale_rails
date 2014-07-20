class Thurs < ActiveRecord::Migration
  def up
    create_table :venues do |t|
      t.string :title
      t.string :address
      t.string :position
      t.string :icon
      t.string :pic
      t.string :map
    end

    def down
      drop_table :venues
    end
  end
end
