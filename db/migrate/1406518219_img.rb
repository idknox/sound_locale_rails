class Img < ActiveRecord::Migration
  def change
    add_column :events, :image, :varchar
  end
end
