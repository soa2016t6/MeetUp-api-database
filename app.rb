# frozen_string_literal: true
require 'sinatra'
require 'econfig'
require 'meetupevents'

class EventsLocatorAPI < Sinatra::Base
  extend Econfig::Shortcut

  Econfig.env = settings.environment.to_s
  Econfig.root = settings.root

  # this is not working! will get 'invalid api key' error in the WebAPI routes responses...
  # the code bellow somehow doesn't define MEETUP_API_KEY environment variable for our meetupevents gem to use
  Meetup::MeetupApi
    .config
    .update(access_key: EventsLocatorAPI.config.MEETUP_API_KEY)

  # this is the fix for problem stated above
  # manually define MEETUP_API_KEY environment variable from credentials stored at config/app.yml
  ENV['MEETUP_API_KEY'] = EventsLocatorAPI.config.MEETUP_API_KEY

  API_VER = 'api/v0.1'

  # root route to test if Web API is up
  get '/?' do
    "EventsLocatorAPI latest version endpoints are at: /#{API_VER}/"
  end

  # route to find groups based on coutry code and location text
  get "/#{API_VER}/groups/meetup/:countrycode/:locationtextquery/?" do
    begin
      response = Meetup::MeetupApi.get_groups(:countrycode, :locationtextquery)

      content_type 'application/json'
      response.to_json

    rescue
      halt 404, "Groups in country at location specified not found"
    end
  end

  # route to find events based on location defined by latitude and longitude
  get "/#{API_VER}/events/meetup/:lat/:lon" do
    begin
      response = Meetup::MeetupApi.get_events(:lat, :lon)

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Events at location latituted+longitude specified not found"
    end
  end

end
