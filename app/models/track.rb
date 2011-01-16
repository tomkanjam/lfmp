class Track < ActiveRecord::Base
  attr_accessible :artist_name, :track_name, :lastfm_id, :yt_url
  belongs_to :playlist
end
