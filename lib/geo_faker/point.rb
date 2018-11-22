class Point
  attr_reader :lat, :lon

  def initialize(lat:, lon:)
    @lat = lat
    @lon = lon
  end
end
