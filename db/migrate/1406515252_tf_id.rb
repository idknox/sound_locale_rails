class TfId < ActiveRecord::Migration
  def change
    add_column :events, :tf_id, :integer
  end
end
