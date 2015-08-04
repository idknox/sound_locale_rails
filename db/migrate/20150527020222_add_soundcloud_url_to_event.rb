
class AddSoundcloudUrlToEvent < ActiveRecord::Migration
  def change
    add_column :events, :soundcloud_url, :string
  end
end
