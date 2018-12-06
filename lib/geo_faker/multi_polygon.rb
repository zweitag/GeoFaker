module GeoFaker
  class MultiPolygon
    attr_reader :coordinates

    def initialize(coordinates)
      @coordinates = coordinates
    end

    def self.from_geojson(geojson)
      case geojson.fetch('type')
      when 'MultiPolygon'
        MultiPolygon.new(geojson.fetch('coordinates'))
      when 'Polygon'
        MultiPolygon.new([geojson.fetch('coordinates')])
      end
    end

    def contains_point(point)
      point_in_poly(coordinates[0][0], point)
    end

    private

    def point_in_poly(poly, point)
      last_point = poly[-1]
      oddNodes = false
      y = point.lon
      x = point.lat

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
end
