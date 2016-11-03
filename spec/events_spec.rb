# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Meetup Events Routes' do

  before do
    VCR.insert_cassette GROUPS_CASSETTE, record: :new_episodes
  end

  after do
    VCR.eject_cassette
  end

  describe 'Find Meetup Events by Location' do
    it 'HAPPY: should find an event given a location' do
      #get "api/v0.1/meetup/events/#{...}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      #group_data = JSON.parse(last_response.body)
      #group_data['group_id'].length.must_be :>, 0
      #group_data['name'].length.must_be :>, 0
    end

    it 'SAD: should report if location does not exist' do
      #get "api/v0.1/meetup/events/#{...}"

      last_response.status.must_equal 404
      #last_response.body.must_include ...
    end
  end

  describe 'Find Meetup Groups by Location Text Query' do
    it 'HAPPY: should find a group given a location' do
      #get "api/v0.1/meetup/groups/#{...}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      #group_data = JSON.parse(last_response.body)
      #group_data['group_id'].length.must_be :>, 0
      #group_data['name'].length.must_be :>, 0
    end
  end

  describe 'Find Cities based on specified Country' do
    it 'HAPPY: should find a city given a country' do
      # get "api/v0.1/meetup/city/#{...}"

      last_response.status.must_equal 200
      last_response.content_type.must_equal 'application/json'
      #group_data = JSON.parse(last_response.body)
      #group_data['group_id'].length.must_be :>, 0
      #group_data['name'].length.must_be :>, 0
    end

    it 'SAD: should report if provided wrong country code (ex: tw -> wt)' do
      # get "api/v0.1/meetup/city/#{...}"

      last_response.status.must_equal 404
      #last_response.body.must_include ...
    end
  end

end
