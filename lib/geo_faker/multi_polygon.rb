module GeoFaker
  class MultiPolygon
    attr_reader :coordinates

    def initialize(coordinates)
      @coordinates = coordinates
    end

    def self.from_geojson(geojson)
      MultiPolygon.new([geojson['coordinates']])
    end
  end
end
