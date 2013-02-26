# 1. Set CREATESEND_CLIENT_ID and CREATESEND_CLIENT_SECRET environment
#    variables for your registered OAuth application.
# 2. `bundle install`
# 3. `rackup`

require 'bundler/setup'
require 'sinatra/base'
#require 'omniauth-createsend'
require 'createsend'

class App < Sinatra::Base
  get '/' do
    redirect CreateSend::CreateSend.authorize_url(
      ENV['CREATESEND_CLIENT_ID'],
      ENV['CREATESEND_REDIRECT_URI'],
      'ViewReports,CreateCampaigns,SendCampaigns')
  end

  get '/exchange_token' do
    code = params['code']
    access_token, expires_in, refresh_token =
      CreateSend::CreateSend.exchange_token ENV['CREATESEND_CLIENT_ID'],
      ENV['CREATESEND_CLIENT_SECRET'], ENV['CREATESEND_REDIRECT_URI'], code

    response = "<pre>"
    response << "Your user is successfully authenticated. Here are the details you need:<br/><br/>"
    response << "access token: #{access_token}<br/>"
    response << "refresh token: #{refresh_token}<br/>"
    response << "expires in: #{expires_in}<br/>"
    response << "<br/><br/>"

    auth = {
      :access_token => access_token,
      :refresh_token => refresh_token
    }
    cs = CreateSend::CreateSend.new auth
    clients = cs.clients

    response << "We've made an API call too. Here are your clients:<br/><br/>"
    response << MultiJson.encode(clients)
    response << "</pre>"
    response
  end

  # get '/auth/createsend/callback' do
  #   access_token = request.env['omniauth.auth']['credentials']['token']
  #   refresh_token = request.env['omniauth.auth']['credentials']['refresh_token']
  #   expires_at = request.env['omniauth.auth']['credentials']['expires_at']
  # 
  #   response = "<pre>"
  #   response << "Your user is successfully authenticated. Here are the details you need:<br/><br/>"
  #   response << "access token: #{access_token}<br/>"
  #   response << "refresh token: #{refresh_token}<br/>"
  #   response << "expires at: #{expires_at}<br/>"
  #   response << "<br/><br/>"
  # 
  #   auth = {
  #     :access_token => access_token,
  #     :refresh_token => refresh_token
  #   }
  #   cs = CreateSend::CreateSend.new auth
  #   clients = cs.clients
  # 
  #   response << "We've made an API call too. Here are your clients:<br/><br/>"
  #   response << MultiJson.encode(clients)
  #   response << "</pre>"
  #   response
  # end

  # get '/auth/failure' do
  #   content_type 'application/json'
  #   MultiJson.encode(request.env)
  # end
end

# use Rack::Session::Cookie
# 
# use OmniAuth::Builder do
#   provider :createsend, ENV['CREATESEND_CLIENT_ID'], ENV['CREATESEND_CLIENT_SECRET'],
#     :scope => 'ViewReports,CreateCampaigns,SendCampaigns'
# end

run App.new
