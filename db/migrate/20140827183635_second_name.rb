class SecondName < ActiveRecord::Migration
  def change
    add_column :venues, :second_name, :string
  end
end
