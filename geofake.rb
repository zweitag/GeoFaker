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

    data.first.slice('lat', 'lon')
  end
end

puts GeoFaker.get_center(ARGV[0])
