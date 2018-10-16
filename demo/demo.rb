require 'sinatra'
require_relative '../src/geofaker'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/api/within' do
  content_type :json

  query = params[:q]
  return {
    bounds: GeoFaker.geo_data(query)['boundingbox'],
    points: GeoFaker.randomize_within_bounds(query),
  }.to_json
end
