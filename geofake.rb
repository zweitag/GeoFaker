require 'rest-client'
require 'json'

module GeoFaker
  BASE_URL = 'https://nominatim.openstreetmap.org/search'

  def self.get_center(query)
    response = RestClient.get(BASE_URL, params: {
      q: query,
      format: 'json',
      limit: 1
    })

    raise "API error: #{response.code}" unless response.code == 200

    data = JSON.parse(response.body)
    raise "No matching result." if data.empty?

    data.first.slice('lat', 'lon').transform_values(&:to_f)
  end

  def self.randomize_around(centerCoordinates, count: 100)
    lat = centerCoordinates['lat']
    lon = centerCoordinates['lon']

    (1..count).map do |_|
      {
        'lat': lat + rand * 6 - 3,
        'lon': lon + rand * 8 - 4
      }
    end
  end
end

File.write('data.js', "loadData(#{GeoFaker.randomize_around(GeoFaker.get_center(ARGV[0])).to_json});")
