# createsendoauthtest

A very simple Sinatra app to demonstrate the recommended way of authenticating with the [Campaign Monitor API](http://www.campaignmonitor.com/api/) from a Ruby environment.

This app makes use of the [omniauth-createsend](https://github.com/jdennes/omniauth-createsend/) OmniAuth strategy for authentication, as well as the [createsend](https://github.com/campaignmonitor/createsend-ruby) gem for making API calls.

To run:

1. Set `CREATESEND_CLIENT_ID` and `CREATESEND_CLIENT_SECRET` environment variables for your registered OAuth application.
2. `bundle install`
3. `foreman start` or `ruby app.rb`
