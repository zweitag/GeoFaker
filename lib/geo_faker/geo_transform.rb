module GeoFaker
  class GeoTransform
    KM_PER_DEGREE_LAT = 110.574
    KM_PER_DEGREE_LON_AT_EQUATOR = 111.320

    def self.km_to_degree_lat(delta_km)
      delta_km / KM_PER_DEGREE_LAT
    end

    def self.km_to_degree_lon(delta_km, lat)
      delta_km / (KM_PER_DEGREE_LON_AT_EQUATOR * Math.cos(lat * Math::PI / 180))
    end
  end
end
