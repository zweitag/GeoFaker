module GeoFaker
  class MultiPolygon
    attr_reader :polygons

    def self.from_geojson(geojson)
      case geojson.fetch('type')
      when 'MultiPolygon'
        MultiPolygon.new(geojson.fetch('coordinates'))
      when 'Polygon'
        MultiPolygon.new([geojson.fetch('coordinates')])
      end
    end

    def contains_point?(point)
      polygons.any? {|polygon_with_holes| polygon_with_holes.contains_point?(point) }
    end

    private

    def initialize(polygons)
      @polygons = polygons.map {|polygon_with_holes| PolygonWithHoles.new(polygon_with_holes) }
    end
  end
end
