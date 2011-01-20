class CreatePlaylists < ActiveRecord::Migration
  def self.up
    create_table :playlists do |t|
      t.string :name
      t.string :playlist_url
      t.integer :user_id
      t.integer :lastfm_id
      t.timestamps
    end
  end

  def self.down
    drop_table :playlists
  end
end
