class AddYtUrlToTracks < ActiveRecord::Migration
  def self.up
    add_column :tracks, :yt_url, :string
  end

  def self.down
    remove_column :tracks, :yt_url
  end
end
