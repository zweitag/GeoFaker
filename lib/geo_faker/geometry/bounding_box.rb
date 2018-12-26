module GeoFaker
  module Geometry
    class BoundingBox
      attr_reader :north, :east, :south, :west

      def initialize(north:, east:, south:, west:)
        @north = north
        @east = east
        @south = south
        @west = west
      end
    end
  end
end
