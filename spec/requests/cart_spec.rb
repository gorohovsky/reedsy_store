require 'rails_helper'

RSpec.describe 'Cart', type: :request do
  describe 'GET /check_price' do
    let(:params) { { products: cart_params } }

    subject do
      get '/check_price', params:, headers: {}
      response
    end

    describe 'success' do
      let(:cart_params) { { MUG: 1, HOODIE: 2, TSHIRT: 3 } }
      let!(:products) { cart_params.keys.map { |code| create(:product, code:) } }
      let(:expected_total) { 36 }
      let(:expected_result) { params.merge(total: expected_total).as_json }

      shared_examples 'valid request' do
        it 'responds with 200 and a total price for the products' do
          expect(subject.status).to eq 200
          expect(JSON.parse(subject.body)).to eq expected_result
        end
      end

      context 'when there are no discounts for the specified products' do
        it_behaves_like 'valid request'

        context 'when some product params are invalid' do
          let(:cart_params) { { MUG: -1, HOODIE: 2, TSHIRT: 0 } }
          let(:expected_total) { 12 }
          let(:expected_result) { { products: { HOODIE: 2 }, total: expected_total }.as_json }

          it_behaves_like 'valid request'
        end
      end

      context "when discounts for the specified products' quantities exist" do
        let!(:discounts) do
          products.each do |product|
            create(:discount, min_product_count: 2, product:)
            FactoryBot.rewind_sequences
          end
        end
        let(:expected_total) { 35.4 }

        it_behaves_like 'valid request'
      end
    end

    describe 'failure' do
      context 'when "products" parameter missing' do
        let(:params) { {} }

        it 'responds with 400 and an error message' do
          expect(subject.status).to eq 400
          expect(subject.body).to include 'param is missing'
        end
      end

      shared_examples 'invalid request' do
        it 'responds with 400 and an error message' do
          expect(subject.status).to eq 400
          expect(JSON.parse(subject.body)['error']).to eq "The 'products' param contains invalid values"
        end
      end

      context 'when "products" parameter contains invalid values' do
        let(:cart_params) do
          {
            mug: 0.9,
            dog: '',
            pen: 'one',
            hat: 'NULL',
            caN: nil,
            Man: -5,
            cap: {},
            bee: []
          }
        end
        it_behaves_like 'invalid request'
      end

      context 'when "products" parameter is not a Hash' do
        let(:cart_params) { 'abracadabra' }
        it_behaves_like 'invalid request'
      end
    end
  end
end
