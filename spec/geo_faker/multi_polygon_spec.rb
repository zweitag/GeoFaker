require 'geo_faker/multi_polygon'
require 'geo_faker/point'

# Test data taken from https://de.wikipedia.org/wiki/GeoJSON
# on 6th of December 2018. The different polygons are drawn there.
module GeoFaker
  RSpec.describe MultiPolygon do
    shared_examples 'a factory method' do
      it 'returns a MultiPolygon object' do
        expect(subject).to be_a_kind_of(MultiPolygon)
      end
    end

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

      describe '#from_geojson' do
        subject { MultiPolygon.from_geojson(geojson) }

        it_behaves_like 'a factory method'

        it 'converts to MultiPolygon by wrapping the coordinate list in another array' do
          expect(subject).to have_attributes(coordinates: [
            [
              [[30, 10], [40, 40], [20, 40], [10, 20], [30, 10]]
            ]
          ])
        end
      end

      describe '#contains_point' do
        let(:multi_polygon) { MultiPolygon.from_geojson(geojson) }

        it 'returns true for contained point' do
          expect(multi_polygon.contains_point(Point.new(lat: 35, lon: 20))).to be(true)
        end

        it 'returns false for outer point' do
          expect(multi_polygon.contains_point(Point.new(lat: 20, lon: 35))).to be(false)
        end
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

      describe '#from_geojson' do
        subject { MultiPolygon.from_geojson(geojson) }

        it_behaves_like 'a factory method'

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
  end
end
