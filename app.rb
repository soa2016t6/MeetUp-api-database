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
    "EventsLocatorAPI latest version endpoints are at: /#{API_VER}/!"
  end

  # route to find groups based on coutry code and location text
  get "/#{API_VER}/groups/meetup/:countrycode/:locationtextquery/?" do
    countrycode = params[:countrycode]
    locationtext = params[:locationtextquery]
    begin
      response = Meetup::MeetupApi.get_groups(countrycode, locationtext)

      # Check if first result matches provided country code, 404 if not
      parsed_response = JSON.parse(response.to_json)
      if parsed_response.first['country'] != countrycode.upcase
        raise "country code does not match to query"
      end

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Groups in country #{countrycode} at location #{locationtext} not found!"
    end
  end

  # route to find events based on location defined by latitude[-90<>90] & longitude[-180<>180]
  get "/#{API_VER}/events/meetup/:lat&:lon" do
    latitude = params[:lat]
    longitude = params[:lon]
    begin
      response = Meetup::MeetupApi.get_events(latitude, longitude)

      content_type 'application/json'
      response.to_json
    rescue
      halt 404, "Events at location (lan:#{latitude} , lon:#{longitude}) not found!"
    end
  end
end
