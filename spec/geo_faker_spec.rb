RSpec.describe GeoFaker do
  it "has a version number" do
    expect(GeoFaker::VERSION).not_to be nil
  end

  describe 'randomize_within_bounds' do
    subject { described_class.randomize_within_bounds('Münster', count: 5) }

    let(:south) { 51.8401448 }
    let(:north) { 52.0600251 }
    let(:east) { 7.7743634 }
    let(:west) { 7.4737853 }

    it 'returns 5 points' do
      expect(subject.count).to eql(5)
    end

    it 'all points within bounding box' do
      subject.each do |point|
        expect(point[:lat]).to be_between(south, north)
        expect(point[:lon]).to be_between(west, east)
      end
    end
  end
end
