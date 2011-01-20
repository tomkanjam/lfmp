require 'lastfm'
require 'youtube_it'


class UsersController < ApplicationController
  before_filter :initialize_user
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end


  def new
    @user = User.new
    
  end


  def edit
    @user = User.find(params[:id])
  end

  def create
    require 'open-uri'
  	LastFM.api_key = "c44173b28da0543a105aece7c1ad4e17"
    LastFM.client_name = "gigkong"
    ytclient = YouTubeIt::Client.new(:dev_key => "AI39si59NcA_DXFPnwRu1g9siXAze22t2YeICB8bt5s6TG7OG9uBvE83qKv2p_GXTKGaIQkd4x3U2aghthm495-g6EhbISvuNg")
    
    #check if user exists and get playlists
    @playlists = LastFM::User.get_playlists(:user => params[:user][:name])
    if @playlists["error"] == 6
      redirect_to("http://192.168.27.65:3000", :notice => 'We couldnt find that Username. Try again!')
    else
      @u = User.find_or_create_by_name(params[:user][:name])
      
      if @playlists["playlists"]["playlist"].respond_to?("first")
        @playlists["playlists"]["playlist"].each do |p|
          url = "lastfm://playlist/" << p["id"]
          @newp = @u.playlists.find_or_create_by_lastfm_id(:lastfm_id => p["id"], :name => p["title"], :playlist_url => url) 
          @tracklist = LastFM::Playlist.fetch(:playlistURL => url)["playlist"]["trackList"]["track"]
          @tracklist.each do |t|
            track_search_name = t["creator"] + " " + t["title"]  
            ytreply = ytclient.videos_by(:query => track_search_name, :max_results => 1, :format => 5, :category => 'music') 
            if ytreply.videos != []
              @newp.tracks.find_or_create_by_track_name_and_artist_name(:track_name => t["title"], :artist_name => t["creator"], :yt_url => ytreply.videos.first.player_url)
            end
          end
        end
  
      elsif @playlists.has_key?("playlists")
        if @playlists["playlists"].has_key?("user")
          redirect_to("http://192.168.27.65:3000", :notice => 'This user does not have any Last.fm playlists') and return
        elsif @playlists["playlists"]["playlist"].has_key?("title")
          url = "lastfm://playlist/" << @playlists["playlists"]["playlist"]["id"]
          @newp = @u.playlists.find_or_create_by_lastfm_id(:lastfm_id => @playlists["playlists"]["playlist"]["id"], :name => @playlists["playlists"]["playlist"]["title"], :playlist_url => url)
          @tracklist = LastFM::Playlist.fetch(:playlistURL => url)["playlist"]["trackList"]["track"]
          @tracklist.each do |t|
            track_search_name = t["creator"] + " " + t["title"]  
            ytreply = ytclient.videos_by(:query => track_search_name, :max_results => 1, :format => 5, :category => 'music')
            if ytreply.videos != []
              @newp.tracks.find_or_create_by_track_name_and_artist_name(:track_name => t["title"], :artist_name => t["creator"], :yt_url => ytreply.videos.first.player_url)
            end
          end
        end
  
      else
        redirect_to("http://192.168.27.65:3000", :notice => 'Sorry, something went wrong. We\'re working on it!') and return
      end
      redirect_to @u
    end 
    
  end

  
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end


  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

 
end
