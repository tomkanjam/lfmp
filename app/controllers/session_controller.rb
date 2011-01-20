class SessionController < ApplicationController
  def new
    request_token = consumer.get_request_token(
      {:oauth_callback => "http://lfmp.heroku.com/session/create" },
      {:scope => "http://gdata.youtube.com"})
    
    # Keep the secret
    session[:oauth_secret] = request_token.secret
    # Redirect to Google for authorization
    redirect_to request_token.authorize_url
  end

  # User authorized us at Google site
  def create
    # Recreate the (now authorized) request token
    request_token = OAuth::RequestToken.new(consumer, 
                                            params[:oauth_token],
                                            session[:oauth_secret])
    #logger.debug "Consumer: #{consuemer} token: #{params[:oauth_token]} secret: #{session[:oauth_secret]}"                                        
    # Swap the authorized request token for an access token                                        
    access_token = request_token.get_access_token(
                      {:oauth_verifier => params[:oauth_verifier]})
    #logger.debug
    # Save the token and secret to the session
    # We use these to recreate the access token
    session[:oauth_token] = access_token.token
    #logger.debug
    session[:oauth_secret] = access_token.secret
    #logger.debug
    redirect_to "http://192.168.27.65:3000"
  end
  
  def destroy
    # User logs out, forget the access token
    reset_session
    redirect_to '/'
  end
end