require "geo_faker/multi_polygon"
require "geo_faker/polygon_with_holes"
require "geo_faker/point"

# Test data taken from https://en.wikipedia.org/wiki/GeoJSON
# on 6th of December 2018. The different polygons are drawn there.
module GeoFaker
  RSpec.describe MultiPolygon do
    shared_examples "a factory method" do
      it "returns a MultiPolygon object" do
        expect(subject).to be_a_kind_of(MultiPolygon)
      end
    end

    context "with single Polygon without holes" do
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

      describe "#from_geojson" do
        subject { MultiPolygon.from_geojson(geojson) }

        it_behaves_like "a factory method"

        it "converts to MultiPolygon with a single PolygonWithHoles without inner_polygonsby wrapping the coordinate list in another array" do
          expect(subject).to have_attributes(
            polygons: [
              a_kind_of(PolygonWithHoles).and(an_object_having_attributes(
                outer_polygon: [[30, 10], [40, 40], [20, 40], [10, 20], [30, 10]],
                inner_polygons: [],
              )),
            ],
          )
        end
      end

      describe "#contains_point?" do
        let(:multi_polygon) { MultiPolygon.from_geojson(geojson) }

        it "returns true for contained point" do
          expect(multi_polygon.contains_point?(Point.new(lat: 35, lon: 20))).to be(true)
        end

        it "returns false for outer point" do
          expect(multi_polygon.contains_point?(Point.new(lat: 20, lon: 35))).to be(false)
        end
      end
    end

    context "with single Polygon without holes" do
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

      describe "#from_geojson" do
        subject { MultiPolygon.from_geojson(geojson) }

        it_behaves_like "a factory method"

        it "converts to MultiPolygon with a single PolygonWithHoles" do
          expect(subject).to have_attributes(
            polygons: [
              a_kind_of(PolygonWithHoles).and(an_object_having_attributes(
                outer_polygon: [[35, 10], [45, 45], [15, 40], [10, 20], [35, 10]],
                inner_polygons: [[[20, 30], [35, 35], [30, 20], [20, 30]]],
              )),
            ],
          )
        end
      end

      describe "#contains_point?" do
        let(:multi_polygon) { MultiPolygon.from_geojson(geojson) }

        it "returns true for contained point" do
          expect(multi_polygon.contains_point?(Point.new(lat: 30, lon: 20))).to be(true)
        end

        it "returns false for point outside of outer polygon" do
          expect(multi_polygon.contains_point?(Point.new(lat: 10, lon: 40))).to be(false)
        end

        it "returns false for point inside of the hole" do
          expect(multi_polygon.contains_point?(Point.new(lat: 30, lon: 30))).to be(false)
        end
      end
    end

    context "with MultiPolygon with two polygons without holes" do
      let(:geojson) do
        JSON.parse(<<~JSON)
          {
            "type": "MultiPolygon",
            "coordinates": [
              [
                [[30, 20], [45, 40], [10, 40], [30, 20]]
              ],
              [
                [[15, 5], [40, 10], [10, 20], [5, 10], [15, 5]]
              ]
            ]
          }
        JSON
      end

      describe "#from_geojson" do
        subject { MultiPolygon.from_geojson(geojson) }

        it_behaves_like "a factory method"

        it "imports the MultiPolygon with two PolygonWithHoles without inner_polygons" do
          expect(subject).to have_attributes(
            polygons: [
              a_kind_of(PolygonWithHoles).and(an_object_having_attributes(
                outer_polygon: [[30, 20], [45, 40], [10, 40], [30, 20]],
                inner_polygons: [],
              )),
              a_kind_of(PolygonWithHoles).and(an_object_having_attributes(
                outer_polygon: [[15, 5], [40, 10], [10, 20], [5, 10], [15, 5]],
                inner_polygons: [],
              )),
            ],
          )
        end
      end

      describe "#contains_point?" do
        let(:multi_polygon) { MultiPolygon.from_geojson(geojson) }

        it "returns true for point inside first polygon" do
          expect(multi_polygon.contains_point?(Point.new(lat: 30, lon: 30))).to be(true)
        end

        it "returns true for point inside second polygon" do
          expect(multi_polygon.contains_point?(Point.new(lat: 10, lon: 20))).to be(true)
        end

        it "returns false for point between polygons" do
          expect(multi_polygon.contains_point?(Point.new(lat: 20, lon: 20))).to be(false)
        end

        it "returns false for point outside of everything" do
          expect(multi_polygon.contains_point?(Point.new(lat: 50, lon: 80))).to be(false)
        end
      end
    end
  end
end
