class Playlist < ActiveRecord::Base
  attr_accessible :name, :lastfm_id, :playlist_url
  belongs_to :user
  has_many :tracks
end
