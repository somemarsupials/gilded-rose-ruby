require File.join(File.dirname(__FILE__), '..', 'lib', 'typed_item') 

describe TypedItem do
  let(:item) { double(:item, name: 'default') }
  subject { described_class.new(item) }
  
  describe '#initialize' do
    before(:each) do 
      allow_any_instance_of(described_class)
        .to receive(:identify).and_return(:type)
    end

    describe 'when created' do
      it 'has item' do
        expect(subject.item).to eq item
      end

      it 'has type' do
        expect(subject.type).to eq :type
      end
    end
  end

  describe '#identify' do
    describe 'when aged brie' do
      it 'identifies aged brie' do
        expect(subject.identify('Aged Brie')).to eq :aged_brie
      end
    end
    
    describe 'when legendary items' do
      it 'identifies sulfuras' do
        expect(subject.identify('Sulfuras')).to eq :legendary
      end

      it 'identifies Hand of Ragnaros' do
        expect(subject.identify('Sulfuras, Hand of Ragnaros'))
          .to eq :legendary
      end
    end

    describe 'when conjured item' do
      it 'identifies conjured item' do
        expect(subject.identify('Conjured Mana Cake')).to eq :conjured
      end
    end

    describe 'when other item' do
      it 'identifies default item' do
        expect(subject.identify('default')).to eq :default
      end
    end
  end
end
