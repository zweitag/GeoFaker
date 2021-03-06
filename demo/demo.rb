require "sinatra"
require "geo_faker"

set :public_folder, File.dirname(__FILE__) + "/public"

get "/api/within" do
  content_type :json

  query = params[:q]

  data = GeoFaker.geo_data(query, with_polygon: true)
  count = (params[:count] || 100).to_i

  json = {
    geojson: data["geojson"],
    points: (1..count).map { |_| GeoFaker.within(query) },
  }

  return json.to_json
end

get "/api/within_bounds" do
  content_type :json

  query = params[:q]
  count = (params[:count] || 100).to_i

  json = {
    bounds: GeoFaker.geo_data(query)["boundingbox"],
    points: (1..count).map { |_| GeoFaker.within_bounds(query) },
  }

  return json.to_json
end

get "/api/around" do
  content_type :json

  query = params[:q]
  radius = (params[:radius] || 10).to_f
  count = (params[:count] || 100).to_i

  json = {
    points: (1..count).map { |_| GeoFaker.around(query, radius_in_km: radius) },
    circle: {
      center: GeoFaker.geo_data(query).slice("lat", "lon"),
      radius: radius,
    },
  }

  return json.to_json
end

# Allow calling api methods without the /api, to render a map in which the
# result of the respective api call will be visualised
get "/*" do
  pass if request.path_info.start_with?("/api")
  content_type :html
  send_file(File.dirname(__FILE__) + "/public/index.html")
end
