module GeoFaker
  class Point
    attr_reader :lat, :lon

    def initialize(lat:, lon:)
      @lat = lat
      @lon = lon
    end

    def to_json(*opts)
      {
        lat: lat,
        lon: lon,
      }.to_json(opts)
    end
  end
end
