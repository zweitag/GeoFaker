module GeoFaker
  class PolygonWithHoles
    def initialize(polygon_with_holes)
      @outer_polygon = polygon_with_holes[0]
      @inner_polygons = polygon_with_holes.slice(1..-1)
    end

    def contains_point?(point)
      point_in_polygon(outer_polygon, point) &&
        inner_polygons.none? {|inner_polygon| point_in_polygon(inner_polygon, point) }
    end

    private

    attr_reader :outer_polygon, :inner_polygons

    def point_in_polygon(polygon, point)
      point_in_polygon = false

      last_point = polygon[-1]
      y = point.lon.to_f
      x = point.lat.to_f

      polygon.each do |p|
        yi = p[0]
        xi = p[1]
        yj = last_point[0]
        xj = last_point[1]
        if yi < y && yj >= y ||
            yj < y && yi >= y
          point_in_polygon = !point_in_polygon if xi + (y - yi) / (yj - yi) * (xj - xi) < x
        end
        last_point = p
      end

      point_in_polygon
    end
  end
end
