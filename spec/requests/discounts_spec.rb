require 'rails_helper'

RSpec.describe '/discounts', type: :request do
  let!(:product) { Product.create!(code: 'PEN', name: 'Reedsy Pen', price: 55.01) }
  let(:common_attributes) { { product_id: product.id, min_product_count: 2, rate: 0.1 } }
  let(:attributes) { common_attributes }

  describe 'GET /index' do
    let!(:discount) { Discount.create!(attributes) }

    it 'renders a successful response' do
      get discounts_url, headers: {}, as: :json
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)[0]).to match discount.as_json
    end
  end

  describe 'GET /show' do
    let!(:discount) { Discount.create!(attributes) }

    it 'renders a successful response' do
      get discount_url(discount), as: :json
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)).to match discount.as_json
    end
  end

  describe 'POST /create' do
    subject do
      post discounts_url, params: { discount: attributes }, headers: {}, as: :json
      response
    end

    context 'with valid parameters' do
      it 'creates a new discount' do
        expect { subject }.to change(Discount, :count).by(1)
      end

      it 'renders a JSON response with the new discount' do
        expect(subject.status).to eq 201
        expect(JSON.parse(subject.body)).to match Discount.last.as_json
      end
    end

    shared_examples 'unsuccessful discount creation' do |param|
      context "when #{param} is not passed" do
        it 'does not create a new discount' do
          expect { subject }.not_to change(Discount, :count)
        end

        it 'responds with 422 and an error message' do
          expect(subject.status).to eq 422
          expect(subject.content_type).to include 'application/json'
          expect(subject.body).not_to be_empty
        end
      end
    end

    context 'with invalid parameters' do
      %i[product_id min_product_count rate].each do |param|
        it_behaves_like 'unsuccessful discount creation', param do
          let(:attributes) { common_attributes.except(param) }
        end
      end
    end
  end

  describe 'PUT /update' do
    let!(:discount) { Discount.create!(attributes) }

    subject do
      put discount_url(discount), params: { discount: new_attributes }, headers: {}, as: :json
      response
    end

    context 'with valid parameters' do
      let(:new_attributes) { { min_product_count: 5, rate: 0.15 } }

      it 'responds with 200 and the updated discount' do
        expect(subject.status).to eq 200
        expect(JSON.parse(subject.body)).to match discount.reload.as_json
      end
    end

    context 'with invalid parameters' do
      context 'when parameters are not passed' do
        let(:new_attributes) { {} }

        it 'responds with 400 and an error message' do
          expect(subject.status).to eq 400
          expect(subject.body).to include 'param is missing'
        end
      end

      shared_examples 'unsuccessful product update' do |param, value|
        let(:new_attributes) { { param => value } }

        it 'responds with 422 and an error message' do
          expect(subject.status).to eq 422
          expect(subject.body).to include 'Must be a number'
          expect(subject.content_type).to include 'application/json'
        end
      end

      %i[min_product_count rate].each do |param|
        ['', 'zero', nil, 0].each do |value|
          it_behaves_like 'unsuccessful product update', param, value
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    let!(:discount) { Discount.create!(attributes) }

    subject do
      delete discount_url(discount), headers: {}, as: :json
      response
    end

    it 'destroys the requested discount and responds with 200' do
      expect { subject }.to change(Discount, :count).by(-1)
      expect(subject.status).to eq 204
    end
  end
end
