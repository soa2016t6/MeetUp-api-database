# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'meetupevents'

class EventsLocatorAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  #FaceGroup::FbApi
  #  .config
  #  .update(client_id: config.FB_CLIENT_ID,
  #          client_secret: config.FB_CLIENT_SECRET)

  API_VER = 'api/v0.1'

  get '/?' do
    "EventsLocatorAPI latest version endpoints are at: /#{API_VER}/"
  end

end
