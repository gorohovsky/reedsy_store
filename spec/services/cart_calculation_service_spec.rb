require 'rails_helper'

RSpec.describe CartCalculationService do
  let(:cart_params) { { 'MUG' => 1, 'PEN' => 2, 'CAN' => 3 } }
  let(:instance) { described_class.new(cart_params) }

  describe '#initialize' do
    it 'stores the provided Hash of product codes and quantities in an instance variable' do
      expect(instance.instance_variable_get(:@cart_params)).to eq cart_params
    end
  end

  describe 'execute' do
    shared_context 'products are found' do
      let!(:products) { codes_to_be_found.map { |code| create(:product, code:) } }
      let(:doubles) do
        products.map { |product| double(code: product.code, product_count: cart_params[product.code], discounted_price: 5) }
      end

      before do
        products.each_with_index do |product, i|
          expect(ProductSet).to receive(:new).with(product, cart_params[product.code]).and_return(doubles[i])
        end
      end
    end

    shared_examples 'correct result' do |total:|
      it 'returns a Hash of found products and their calculated total' do
        expect(instance.execute).to eq(products: cart_params.slice(*codes_to_be_found), total:)
      end
    end

    context 'when ALL the specified products are found' do
      let(:codes_to_be_found) { cart_params.keys }
      include_context 'products are found'
      it_behaves_like 'correct result', total: 15
    end

    context 'when SOME specified products are missing' do
      let(:codes_to_be_found) { cart_params.keys[1..] }
      include_context 'products are found'
      it_behaves_like 'correct result', total: 10
    end

    context 'when NO products found' do
      it 'returns a Hash with no products and 0 total' do
        expect(instance.execute).to eq(products: {}, total: 0)
      end
    end
  end
end
