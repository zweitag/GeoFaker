require 'rest-client'
require 'json'

module GeoFaker
  BASE_URL = 'https://nominatim.openstreetmap.org/search'

  @@geo_data = {}

  def self.geo_data(query)
    @@geo_data[query] ||= load_geo_data(query)
  end

  def self.load_geo_data(query)
    response = RestClient.get(BASE_URL, params: {
      q: query,
      format: 'json',
      limit: 1
    })

    raise "API error: #{response.code}" unless response.code == 200

    data = JSON.parse(response.body)
    raise "No matching result." if data.empty?
    data.first
  end

  def self.randomize_around(query, count: 100)
    data = geo_data(query)
    lat = data['lat'].to_f
    lon = data['lon'].to_f

    (1..count).map do |_|
      {
        'lat': lat + rand * 6 - 3,
        'lon': lon + rand * 8 - 4
      }
    end
  end

  def self.randomize_within_bounds(query, count: 200)
    data = geo_data(query)
    bounds = data['boundingbox'].map(&:to_f)

    south = bounds[0]
    north = bounds[1]
    west = bounds[2]
    east = bounds[3]

    (1..count).map do |_|
      {
        'lat': rand(south..north),
        'lon': rand(west..east)
      }
    end
  end
end

File.write('data.js', "loadData(#{{
  bounds: GeoFaker.geo_data(ARGV[0])['boundingbox'].map(&:to_f),
  points: GeoFaker.randomize_within_bounds(ARGV[0])
}.to_json});")
