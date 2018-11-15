RSpec.describe GeoFaker do
  it "has a version number" do
    expect(GeoFaker::VERSION).not_to be nil
  end

  describe 'within_bounds' do
    subject do
      VCR.use_cassette("münster") do
        described_class.within_bounds('Münster')
      end
    end

    let(:south) { 51.8401448 }
    let(:north) { 52.0600251 }
    let(:east) { 7.7743634 }
    let(:west) { 7.4737853 }

    it 'returns a point within bounding box' do
      expect(subject[:lat]).to be_between(south, north)
      expect(subject[:lon]).to be_between(west, east)
    end
  end

  describe 'within' do
    subject do
      VCR.use_cassette("münster_polygon") do
        described_class.within('Münster')
      end
    end

    let(:south) { 51.8401448 }
    let(:north) { 52.0600251 }
    let(:east) { 7.7743634 }
    let(:west) { 7.4737853 }

    it 'returns a point within bounding box' do
      expect(subject[:lat]).to be_between(south, north)
      expect(subject[:lon]).to be_between(west, east)
    end
  end
end
