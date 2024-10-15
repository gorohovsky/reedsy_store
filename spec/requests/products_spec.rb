require 'rails_helper'

RSpec.describe '/products', type: :request do
  let(:attributes) { { code: 'PEN', name: 'Reedsy Pen', price: 55.01 } }
  let!(:product) { Product.create! attributes }

  describe 'GET /index' do
    subject do
      get products_url, headers: {}, as: :json
      response
    end

    it 'renders a successful response' do
      expect(subject.status).to eq 200
      expect(JSON.parse(subject.body)[0]).to match product.as_json
    end
  end

  describe 'PUT /update' do
    let(:new_attributes) { { price: price } }

    subject do
      put product_url(product), params: { product: new_attributes }, headers: {}, as: :json
      response
    end

    shared_examples 'successful product update' do
      it 'updates the requested product' do
        expect { subject }.to change { product.reload.price }.to new_attributes[:price]
      end

      it 'renders a JSON response with the product' do
        expect(subject.status).to eq 200
        expect(JSON.parse(subject.body)).to match product.reload.as_json
      end
    end

    context 'with valid parameters' do
      let(:price) { 30.67 }

      it_behaves_like 'successful product update'
    end

    context 'with unpermitted parameters' do
      let(:new_attributes) { { code: 'PNCL', name: 'Pencil', price: 75 } }

      it 'ignores them' do
        subject
        expect(product.reload.code).to eq attributes[:code]
        expect(product.name).to eq attributes[:name]
      end

      it_behaves_like 'successful product update'
    end

    context 'with invalid parameters' do
      context 'when price is not passed' do
        let(:new_attributes) { {} }

        it 'responds with 400 and an error message' do
          expect(subject.status).to eq 400
          expect(subject.body).to include 'param is missing'
        end
      end

      shared_examples 'unsuccessful product update' do
        it 'responds with 422 and an error message' do
          expect(subject.status).to eq 422
          expect(subject.body).to include 'Must be a number greater than 0'
        end
      end

      context 'when price has incorrect value' do
        ['', 'zero', nil, 0].each do |value|
          it_behaves_like 'unsuccessful product update' do
            let(:price) { value }
          end
        end
      end
    end
  end
end
