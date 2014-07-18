class Thurs < ActiveRecord::Migration
  def up
    create_table :venues do |t|
      t.string :title
      t.string :position
      t.string :icon
    end

    def down
      drop_table :venues
    end
  end
end
