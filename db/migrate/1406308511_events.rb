class Events < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :name
      t.string :headliner
      t.date :date
      t.string :tickets
      t.float :price
      t.string :url
      t.string :twitter
    end
  end

  def down
    drop_table :events
  end

end
