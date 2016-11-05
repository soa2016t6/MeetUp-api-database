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

  # root route to test if Web API is up
  get '/?' do
    "EventsLocatorAPI latest version endpoints are at: /#{API_VER}/"
  end

  # route to find groups based on coutry code and location text
  get '/#{API_VER}/groups/meetup/:countrycode/:locationtextquery/?' do
    begin
      response = Meetup::MeetupApi.get_groups(:countrycode, :locationtextquery)

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Groups in country '#{:countrycode}' at location '#{:locationtextquery}' not found"
    end
  end

  # route to find events based on location defined by latitude and longitude
  get '/#{API_VER}/events/meetup/:lat/:lon' do
    begin
      response = Meetup::MeetupApi.get_events(:lat, :lon)

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Events at location (lat:'#{:lat}',lon:'#{:locationtextquery}') not found"
    end
  end

end
