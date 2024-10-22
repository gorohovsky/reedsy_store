require 'rails_helper'

RSpec.describe ProductSet do
  let(:product) { create(:product) }
  let(:product_count) { 11 }
  let(:instance) { described_class.new(product, product_count) }

  after { FactoryBot.rewind_sequences }

  context 'when a suitable discount for the specified number of products exists' do
    let!(:discounts) { create_list(:discount, 3, product: product) }

    describe '#discount_rate' do
      it 'returns its value as a decimal' do
        expect(instance.discount_rate).to eq 0.04
      end
    end

    describe '#discount' do
      subject { instance.discount }

      it 'returns the discount model' do
        expect(subject).to be_a Discount
        expect(subject.as_json).to include('product_id' => product.id, 'min_product_count' => 10, 'rate' => 0.04)
      end
    end

    describe '#price_coeffient' do
      it 'returns an after-discount price portion, expressed as a decimal' do
        expect(instance.price_coefficient).to eq 0.96
      end
    end

    describe '#discounted_price' do
      it 'returns a price of the product set, including the discount' do
        expect(instance.discounted_price).to eq 63.36
      end
    end
  end

  context 'when there is no discount for the specified number of products' do
    let!(:discount) { create(:discount, product: product, min_product_count: 50) }

    describe '#discount_rate' do
      it 'returns 0' do
        expect(instance.discount_rate).to eq 0
      end
    end

    describe '#discount' do
      it 'returns nil' do
        expect(instance.discount).to be_nil
      end
    end

    describe '#price_coeffient' do
      it 'equals 1' do
        expect(instance.price_coefficient).to eq 1
      end
    end

    describe '#discounted_price' do
      it 'returns a complete price of the product set' do
        expect(instance.discounted_price).to eq 66
      end
    end
  end
end
