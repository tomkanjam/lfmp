class AddLastfmIdToPlaylists < ActiveRecord::Migration
  def self.up
    add_column :playlists, :lastfm_id, :integer
  end

  def self.down
    remove_column :playlists, :lastfm_id
  end
end
