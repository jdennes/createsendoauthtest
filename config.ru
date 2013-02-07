require 'bundler/setup'
require 'sinatra/base'
require 'omniauth-createsend'
require 'createsend'

class App < Sinatra::Base
  get '/' do
    redirect '/auth/createsend'
  end

  get '/auth/createsend/callback' do
    access_token = request.env['omniauth.auth']['credentials']['token']
    refresh_token = request.env['omniauth.auth']['credentials']['refresh_token']
    expires_at = request.env['omniauth.auth']['credentials']['expires_at']
    
    response = "Your user is successfully authenticated. Here are you details you need:<br/><br/>"
    response << "access token: #{access_token}<br/>"
    response << "refresh token: #{refresh_token}<br/>"
    response << "expires at: #{expires_at}<br/>"
    response << "<br/><br/>"
    
    CreateSend.oauth access_token, refresh_token
    cs = CreateSend::CreateSend.new
    clients = cs.clients

    response << "We've made an API call too. Here are your clients:<br/><br/>"
    response << MultiJson.encode(clients)
    response
  end

  get '/auth/failure' do
    content_type 'application/json'
    MultiJson.encode(request.env)
  end
end

use Rack::Session::Cookie

use OmniAuth::Builder do
  provider :createsend, ENV['CREATESEND_CLIENT_ID'], ENV['CREATESEND_CLIENT_SECRET'],
    :scope => 'ViewReports,CreateCampaigns,SendCampaigns'
end

run App.new
