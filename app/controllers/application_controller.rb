# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
  def initialize_user
    # If we have oauth_token and oauth_secret, we
    # can recreate the access token needed for
    # YouTube API communication on behalf of the
    # user
    if session[:oauth_token] && session[:oauth_secret]
      @access_token ||= OAuth::AccessToken.new(
                                consumer, 
                                session[:oauth_token], 
                                session[:oauth_secret])
    end
  end

  # This is the OAuth::Consumer we use to communicate
  # with Google
  def consumer
    @consumer ||= begin
      options = {
          :site => "https://www.google.com",
          :request_token_path => "/accounts/OAuthGetRequestToken",
          :access_token_path => "/accounts/OAuthGetAccessToken",
          :authorize_path=> "/accounts/OAuthAuthorizeToken"
        }
    
      OAuth::Consumer.new('lfmp.heroku.com', 'EqH7lROs9KwfSU3QnFpkd8tX', options)
    end
  end

end
