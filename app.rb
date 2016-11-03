# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'meetupevents'

class EventsLocatorAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  Meetup::MeetupApi
    .config
    .update(access_key: config.MEETUP_API_KEY)

  API_VER = 'api/v0.1'

  get '/?' do
    "EventsLocatorAPI latest version endpoints are at: /#{API_VER}/"
  end

end
