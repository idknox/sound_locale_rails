class Users < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password
      t.date :birthdate
      t.date :join_date
    end

    create_table :venues do |t|
      t.string :title
      t.string :position
      t.string :icon
      t.string :marker_name
      t.string :address
      t.string :size
      t.string :price
      t.string :map
      t.string :logo
      t.string :background
      t.string :site
      t.string :name
    end

    create_table :events do |t|
      t.string :name
      t.string :headliner
      t.datetime :time
      t.string :tickets
      t.string :url
      t.string :twitter
      t.string :venue
      t.string :price
      t.integer :vendor_id
      t.string :image
    end
  end
end