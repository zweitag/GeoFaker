require 'geo_faker/geo_transform'
require 'geo_faker/version'
require 'rest-client'
require 'json'
require 'pry'

module GeoFaker
  BASE_URL = 'https://nominatim.openstreetmap.org/search'

  @@geo_data = {}

  def self.geo_data(query, with_polygon: false)
    @@geo_data[query] ||= load_geo_data(query, with_polygon: with_polygon)
    if with_polygon && !@@geo_data[query].key?('geojson')
      @@geo_data[query] = load_geo_data(query, with_polygon: with_polygon)
    end
    @@geo_data[query]
  end

  def self.load_geo_data(query, with_polygon: false)
    response = RestClient.get(BASE_URL, params: {
      q: query,
      format: 'json',
      limit: 1,
      polygon_geojson: with_polygon ? '1' : '0',
    })

    raise "API error: #{response.code}" unless response.code == 200

    data = JSON.parse(response.body)
    raise "No matching result." if data.empty?
    data.first
  end

  def self.around(query, radius_in_km:)
    data = geo_data(query)
    lat = data['lat'].to_f
    lon = data['lon'].to_f

    angle = 2 * Math::PI * rand()
    distance = nil
    loop do
      distance = radius_in_km * gaussian_rand()
      break if distance.abs < 3 * radius_in_km
    end

    delta_lat = GeoTransform.km_to_degree_lat(distance * Math.cos(angle))
    delta_lon = GeoTransform.km_to_degree_lon(distance * Math.sin(angle), lat)

    {
      lat: lat + delta_lat,
      lon: lon + delta_lon,
    }
  end

  def self.gaussian_rand
    theta = 2 * Math::PI * rand
    rho = Math.sqrt(-2 * Math.log(1 - rand))
    x = rho * Math.cos(theta)
    #y = rho * Math.sin(theta)
    x
  end

  def self.within_bounds(query)
    data = geo_data(query)
    bounds = data['boundingbox'].map(&:to_f)

    south = bounds[0]
    north = bounds[1]
    west = bounds[2]
    east = bounds[3]

    {
      lat: rand(south..north),
      lon: rand(west..east),
    }
  end

  def self.within(query)
    data = geo_data(query, with_polygon: true)

    bounds = data['boundingbox'].map(&:to_f)
    south = bounds[0]
    north = bounds[1]
    west = bounds[2]
    east = bounds[3]

    geojson = data['geojson']
    raise 'geojson is not Polygon' unless geojson['type'] == 'Polygon'
    outer_poly = geojson['coordinates'][0]

    loop do
      point = {
        'lat': rand(south..north),
        'lon': rand(west..east)
      }

      return point if point_in_poly(outer_poly, point)
    end
  end

  def self.point_in_poly(poly, point)
    last_point = poly[-1]
    oddNodes = false
    y = point[:lon]
    x = point[:lat]

    poly.each do |p|
      yi = p[0]
      xi = p[1]
      yj = last_point[0]
      xj = last_point[1]
      if yi < y && yj >= y ||
          yj < y && yi >= y
        oddNodes = !oddNodes if xi + (y - yi) / (yj - yi) * (xj - xi) < x
      end
      last_point = p
    end

    oddNodes
  end
end
