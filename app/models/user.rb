class User < ActiveRecord::Base
  attr_accessible :name
  has_many :playlists
 
  validates_presence_of :name
  validates_length_of   :name, :maximum => 50
  
end
