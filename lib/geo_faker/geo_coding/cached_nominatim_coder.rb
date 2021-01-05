require 'geo_faker/geo_coding/result'
require 'geo_faker/geometry/point'
require 'geo_faker/geometry/bounding_box'
require 'geo_faker/geometry/multi_polygon'
require 'rest-client'

module GeoFaker
  module GeoCoding
    module CachedNominatimCoder
      BASE_URL = 'https://nominatim.openstreetmap.org/search'

      @@geo_data = {}

      def self.geo_data(query, with_polygon: false)
        @@geo_data[query] ||= load_geo_data(query, with_polygon: with_polygon)
        if with_polygon && @@geo_data[query].bounding_polygon == nil
          @@geo_data[query] = load_geo_data(query, with_polygon: with_polygon)
        end
        @@geo_data[query]
      end

      private

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
        parse_result(data.first)

      end

      def self.parse_result(json)
        Result.new(
          center: Geometry::Point.new(lat: json['lat'].to_f, lon: json['lon'].to_f),
          bounding_box: parse_bounding_box(json),
          bounding_polygon: parse_bounding_polygon(json),
        )
      end

      def self.parse_bounding_box(json)
        bounds = json['boundingbox'].map(&:to_f)

        Geometry::BoundingBox.new(
          south: bounds[0],
          north: bounds[1],
          west: bounds[2],
          east: bounds[3],
        )
      end

      def self.parse_bounding_polygon(json)
        if json.key?('geojson')
          Geometry::MultiPolygon.from_geojson(json['geojson'])
        else
          nil
        end
      end
    end
  end
end
