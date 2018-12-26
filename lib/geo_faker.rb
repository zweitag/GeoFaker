require 'geo_faker/version'
require 'geo_faker/geo_coding/coder'
require 'geo_faker/geometry/geo_transform'
require 'geo_faker/geometry/polygon_with_holes'
require 'geo_faker/geometry/multi_polygon'
require 'geo_faker/geometry/point'
require 'rest-client'
require 'json'
require 'pry'

module GeoFaker
  def self.around(query, radius_in_km:)
    result = GeoCoding::Coder.geo_data(query)

    angle = 2 * Math::PI * rand()
    distance = nil
    loop do
      distance = radius_in_km * gaussian_rand()
      break if distance.abs < 3 * radius_in_km
    end

    delta_lat = Geometry::GeoTransform.km_to_degree_lat(distance * Math.cos(angle))
    delta_lon = Geometry::GeoTransform.km_to_degree_lon(distance * Math.sin(angle), result.center.lat)

    Geometry::Point.new(
      lat: result.center.lat + delta_lat,
      lon: result.center.lon + delta_lon,
    )
  end

  def self.gaussian_rand
    theta = 2 * Math::PI * rand
    rho = Math.sqrt(-2 * Math.log(1 - rand))
    x = rho * Math.cos(theta)
    #y = rho * Math.sin(theta)
    x
  end

  def self.within_bounds(query)
    result = GeoCoding::Coder.geo_data(query)
    bounds = result.bounding_box

    Geometry::Point.new(
      lat: rand(bounds.south..bounds.north),
      lon: rand(bounds.west..bounds.east),
    )
  end

  def self.within(query)
    result = GeoCoding::Coder.geo_data(query, with_polygon: true)
    bounds = result.bounding_box

    loop do
      point = Geometry::Point.new(
        lat: rand(bounds.south..bounds.north),
        lon: rand(bounds.west..bounds.east),
      )

      return point if result.bounding_polygon.contains_point?(point)
    end
  end
end
