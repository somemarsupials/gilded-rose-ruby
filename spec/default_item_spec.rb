require File.join(File.dirname(__FILE__), '..', 'lib', 'default_item') 

require 'set'

class MockItem
  attr_accessor :sell_in, :quality
end

shared_examples 'default item' do
  let(:item) { MockItem.new }
  let(:params) {{ 
    sell_in_incr: 1, quality_incr: 3, expiry_mul: 2, 
    quality_max: 100, expiry: 0
  }}

  subject { described_class.new(item, params) }

  describe '#initialize' do
    describe 'when created' do
      let(:original_keys) { params.keys.to_set }
      let(:new_keys) { subject.params.keys.to_set }

      it 'has item' do
        expect(subject.item).to eq item
      end

      it 'has params' do
        expect(new_keys).to be_superset original_keys
      end
    end
  end

  describe '#update' do
    after(:each) { subject.update }
    before(:each) { allow(subject).to receive(:update_sell_in) }
    before(:each) { allow(subject).to receive(:update_quality) }

    describe 'when updating all' do
      it 'updates sell-in' do
        expect(subject).to receive(:update_sell_in)
      end

      it 'updates quality' do
        expect(subject).to receive(:update_quality)
      end
    end
  end
end


describe DefaultItem do
  include_examples 'default item'

  describe '#update_sell_in' do
    before(:each) { allow(item).to receive(:sell_in).and_return(0) }
    after(:each) { subject.update_sell_in }

    describe 'when updating sell-in value' do
      it 'updates sell-in by paramater value' do
        expect(item).to receive(:sell_in=).with(1)
      end
    end
  end

  describe '#update_quality' do
    before(:each) { allow(item).to receive(:quality).and_return(0) }
    before(:each) { allow(item).to receive(:sell_in).and_return(0) }
    after(:each) { subject.update_quality }

    describe 'when expired' do
      before(:each) { allow(item).to receive(:sell_in).and_return(-5) }

      it 'adds quality increment by expiry muliplier' do
        expect(item).to receive(:quality=).with(6)
      end
    end

    describe 'when not expired' do
      before(:each) { allow(item).to receive(:sell_in).and_return(5) }

      it 'adds quality increment' do
        expect(item).to receive(:quality=).with(3)
      end
    end

    describe 'when above limit' do
      before(:each) { allow(item).to receive(:quality).and_return(150) }

      it 'sets quality to upper bound' do
        expect(item).to receive(:quality=).with(100)
      end
    end
  end
end
