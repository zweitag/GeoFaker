module GeoFaker
  module GeoCoding
    class Result
      attr_reader :center
      attr_reader :bounding_box
      attr_reader :bounding_polygon

      def initialize(center:, bounding_box:, bounding_polygon:)
        @center = center
        @bounding_box = bounding_box
        @bounding_polygon = bounding_polygon
      end
    end
  end
end
