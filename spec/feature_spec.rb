require File.join(File.dirname(__FILE__), 'texttest_fixture')
require File.join(File.dirname(__FILE__), '..', 'lib', 'gilded_rose')

describe 'Feature tests' do
  subject { GildedRose.new(items) }
  before(:each) { subject.update }

  describe '#update' do
    let(:brie) do 
      subject.items.select { |i| i.item.name == 'Aged Brie' }.first
    end

    it 'adds one to brie items' do
      expect(brie.item.quality).to eq 1
    end
  end
end
