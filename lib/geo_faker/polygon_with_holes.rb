module GeoFaker
  class PolygonWithHoles
    def initialize(polygon_with_holes)
      @outer_polygon = polygon_with_holes[0]
      @inner_polygons = polygon_with_holes.slice(1..-1)
    end

    def contains_point?(point)
      point_in_polygon = false

      last_point = outer_polygon[-1]
      y = point.lon.to_f
      x = point.lat.to_f

      outer_polygon.each do |p|
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

    private

    attr_reader :outer_polygon, :inner_polygons
  end
end
