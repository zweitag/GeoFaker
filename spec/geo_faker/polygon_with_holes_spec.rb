require 'geo_faker/polygon_with_holes'
require 'geo_faker/point'

RSpec.describe GeoFaker::PolygonWithHoles do
  describe '#contains_point?' do
    subject { described_class.new(polygons).contains_point?(point) }

    let(:polygons) do
      [
        [[0, 0], [3, 0], [3, 3], [0, 3]],
        [[1, 1], [2, 1], [2, 2], [1, 2]],
      ]
    end

    context 'point inside of outer polygon' do
      context 'outside its hole' do
        let(:point) { GeoFaker::Point.new(lat: 0.5, lon: 0.5) }
        it { is_expected.to be true }
      end

      context 'inside its hole' do
        let(:point) { GeoFaker::Point.new(lat: 1.5, lon: 1.5) }
        it { is_expected.to be false }
      end
    end

    context 'point outside of outer polygon' do
      let(:point) { GeoFaker::Point.new(lat: 1.5, lon: 1.5) }
      it { is_expected.to be false }
    end
  end
end
