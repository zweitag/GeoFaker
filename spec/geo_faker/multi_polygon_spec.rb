require 'geo_faker/multi_polygon'

# Test data taken from https://de.wikipedia.org/wiki/GeoJSON
# on 6th of December 2018. The different polygons are drawn there.
RSpec.describe GeoFaker::MultiPolygon do
  describe '#from_geojson' do
    subject { GeoFaker::MultiPolygon.from_geojson(geojson) }

    context 'with single Polygon without holes' do
      let(:geojson) do
        JSON.parse(<<~JSON)
          {
            "type": "Polygon",
            "coordinates": [
               [[30, 10], [40, 40], [20, 40], [10, 20], [30, 10]]
            ]
          }
        JSON
      end

      it 'returns a MultiPolygon object' do
        expect(subject).to be_a_kind_of(GeoFaker::MultiPolygon)
      end

      it 'converts to MultiPolygon by wrapping the coordinate list in another array' do
        expect(subject).to have_attributes(coordinates: [
          [
            [[30, 10], [40, 40], [20, 40], [10, 20], [30, 10]]
          ]
        ])
      end
    end

    context 'with single Polygon without holes' do
      let(:geojson) do
        JSON.parse(<<~JSON)
          {
            "type": "Polygon",
            "coordinates": [
              [[35, 10], [45, 45], [15, 40], [10, 20], [35, 10]],
              [[20, 30], [35, 35], [30, 20], [20, 30]]
            ]
          }
        JSON
      end

      it 'converts to MultiPolygon by wrapping the coordinate list in another array' do
        expect(subject).to have_attributes(coordinates: [
          [
            [[35, 10], [45, 45], [15, 40], [10, 20], [35, 10]],
            [[20, 30], [35, 35], [30, 20], [20, 30]]
          ]
        ])
      end
    end
  end

  describe '#contains_point' do
  end
end
