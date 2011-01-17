class AddPlaylistUrlToPlaylists < ActiveRecord::Migration
  def self.up
    add_column :playlists, :playlist_url, :string
  end

  def self.down
    remove_column :playlists, :playlist_url
  end
end
