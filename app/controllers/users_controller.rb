require 'lastfm'

class UsersController < ApplicationController
   
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
    
    #check if user exists and get playlists
    @p = LastFM::User.get_playlists(:user => params[:user][:name])
    if @p["error"] == 6
      redirect_to(root, :notice => 'We couldn\'t find the Username \"params[:user][:name]\". Try again!')
    else
      @u = User.find_or_create_by_name(params[:user][:name])
      if @p["playlists"]["playlist"].first.empty? == false
        @p["playlists"]["playlist"].each do |p|
          @np = @u.playlists.build(:name => p["title"])  
          @np.save  
        end
      elsif @p["playlists"]["playlist"]["title"]
        @np = @u.playlists.build(:name => @p["playlists"]["playlist"]["title"])  
        @np.save
      else
        redirect_to(root, :notice => 'Sorry, something went wrong. We\'re working on it!')
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
