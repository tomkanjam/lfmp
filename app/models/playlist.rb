class Playlist < ActiveRecord::Base
  attr_accessible :name, :lastfm_id
  belongs_to :user
end
