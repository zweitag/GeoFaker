require 'sinatra'
require_relative '../src/geofaker'

set :public_folder, File.dirname(__FILE__) + '/public'

get '/api/within' do
  content_type :json

  query = params[:q]

  data = GeoFaker.geo_data(query, with_polygon: true)

  return {
    geojson: data['geojson'],
    points: GeoFaker.randomize_within(query),
  }.to_json
end

get '/api/within_bounds' do
  content_type :json

  query = params[:q]
  return {
    bounds: GeoFaker.geo_data(query)['boundingbox'],
    points: GeoFaker.randomize_within_bounds(query),
  }.to_json
end

get '/api/around' do
  content_type :json

  query = params[:q]
  radius = (params[:radius] || 10).to_i

  return {
    points: GeoFaker.randomize_around(query, radius_in_km: radius),
  }.to_json
end

# Allow calling api methods without the /api, to render a map in which the
# result of the respective api call will be visualised
get '/*' do
  pass if request.path_info.start_with?('/api')
  content_type :html
  send_file(File.dirname(__FILE__) + '/public/index.html')
end
