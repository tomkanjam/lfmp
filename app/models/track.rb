class Track < ActiveRecord::Base
  attr_accessible :artist_name, :track_name, :lastfm_id
  belongs_to :playlist
end
