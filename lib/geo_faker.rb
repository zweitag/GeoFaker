require "geo_faker/version"
require "geo_faker/geo_transform"
require "geo_faker/polygon_with_holes"
require "geo_faker/multi_polygon"
require "geo_faker/point"
require "rest-client"
require "json"
require "pry"

module GeoFaker
  BASE_URL = "https://nominatim.openstreetmap.org/search".freeze

  @geo_data = {}

  def self.geo_data(query, with_polygon: false)
    @geo_data[query] ||= load_geo_data(query, with_polygon: with_polygon)
    @geo_data[query] = load_geo_data(query, with_polygon: with_polygon) if with_polygon && !@geo_data[query].key?("geojson")
    @geo_data[query]
  end

  def self.load_geo_data(query, with_polygon: false)  # rubocop:disable Metrics/MethodLength
    response = RestClient.get(
      BASE_URL,
      params: {
        q: query,
        format: "json",
        limit: 1,
        polygon_geojson: with_polygon ? "1" : "0",
      },
    )

    raise "API error: #{response.code}" unless response.code == 200

    data = JSON.parse(response.body)
    raise "No matching result." if data.empty?
    data.first
  end

  def self.around(query, radius_in_km:) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    data = geo_data(query)
    lat = data["lat"].to_f
    lon = data["lon"].to_f

    angle = 2 * Math::PI * rand
    distance = nil
    loop do
      distance = radius_in_km * gaussian_rand
      break if distance.abs < 3 * radius_in_km
    end

    delta_lat = GeoTransform.km_to_degree_lat(distance * Math.cos(angle))
    delta_lon = GeoTransform.km_to_degree_lon(distance * Math.sin(angle), lat)

    Point.new(
      lat: lat + delta_lat,
      lon: lon + delta_lon,
    )
  end

  def self.gaussian_rand
    theta = 2 * Math::PI * rand
    rho = Math.sqrt(-2 * Math.log(1 - rand))
    rho * Math.cos(theta)
  end

  def self.within_bounds(query)
    data = geo_data(query)
    bounds = data["boundingbox"].map(&:to_f)

    south = bounds[0]
    north = bounds[1]
    west = bounds[2]
    east = bounds[3]

    Point.new(
      lat: rand(south..north),
      lon: rand(west..east),
    )
  end

  def self.within(query) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    data = geo_data(query, with_polygon: true)

    bounds = data["boundingbox"].map(&:to_f)
    south = bounds[0]
    north = bounds[1]
    west = bounds[2]
    east = bounds[3]

    geojson = data["geojson"]
    raise "geojson must be either Polygon or MultiPolygon" unless %w[Polygon MultiPolygon].include?(geojson["type"])
    multi_polygon = MultiPolygon.from_geojson(geojson)

    loop do
      point = Point.new(
        lat: rand(south..north),
        lon: rand(west..east),
      )

      return point if multi_polygon.contains_point?(point)
    end
  end
end
