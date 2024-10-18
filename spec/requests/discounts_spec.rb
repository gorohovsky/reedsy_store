require 'rails_helper'

RSpec.describe '/discounts', type: :request do
  let!(:product) { Product.create!(code: 'PEN', name: 'Reedsy Pen', price: 55.01) }
  let(:common_attributes) { { min_product_count: 2, rate: 0.1 } }
  let(:attributes) { common_attributes.merge!(product_id: product.id) }

  shared_context 'multiple products' do
    let!(:product2) { Product.create!(code: 'HAT', name: 'Reedsy Hat', price: 100.12) }
    let!(:product2_discount) { Discount.create!(attributes.merge!(product_id: product2.id)) }
  end

  shared_context 'nonexistent product' do
    let(:requested_product) { Product.new(id: 0) }
  end

  shared_examples '"not found" response' do |model|
    it 'responds with 404 and an error message' do
      expect(subject.status).to eq 404
      expect(subject.body).to include "Couldn't find #{model.name}"
    end
  end

  describe 'GET /index' do
    subject do
      get product_discounts_url(requested_product), headers: {}, as: :json
      response
    end

    describe 'success' do
      let(:requested_product) { product }
      let!(:discount) { Discount.create!(attributes) }

      include_context 'multiple products'

      it 'responds with 200 and discounts related to the specified product' do
        expect(Discount.count).to eq 2
        expect(subject.status).to eq 200

        JSON.parse(subject.body).tap do |discounts|
          expect(discounts.size).to eq 1
          expect(discounts[0]).to eq discount.as_json
        end
      end
    end

    describe 'failure' do
      context 'when the requested product does not exist' do
        include_context 'nonexistent product'
        it_behaves_like '"not found" response', Product
      end
    end
  end

  describe 'GET /show' do
    let!(:discount) { Discount.create!(attributes) }

    subject do
      get product_discount_url(requested_product, discount), as: :json
      response
    end

    describe 'success' do
      let(:requested_product) { product }

      it 'responds with 200 and the requested discount' do
        expect(subject.status).to eq 200
        expect(JSON.parse(subject.body)).to eq discount.as_json
      end
    end

    describe 'failure' do
      context 'when the discount belongs to another product' do
        include_context 'multiple products'
        let(:requested_product) { product2 }
        it_behaves_like '"not found" response', Discount
      end

      context 'when the requested product does not exist' do
        include_context 'nonexistent product'
        it_behaves_like '"not found" response', Product
      end
    end
  end

  describe 'POST /create' do
    let(:attributes) { common_attributes }
    let(:requested_product) { product }

    subject do
      post product_discounts_url(requested_product), params: { discount: attributes }, headers: {}, as: :json
      response
    end

    describe 'success' do
      context 'with valid parameters' do
        it 'creates a new discount' do
          expect { subject }.to change(Discount, :count).by(1)
        end

        it 'responds with 201 and the new discount' do
          expect(subject.status).to eq 201
          Discount.last.tap do |discount|
            expect(JSON.parse(subject.body)).to eq discount.as_json
            expect(headers['location']).to eq product_discount_url(requested_product, discount)
          end
        end
      end
    end

    describe 'failure' do
      shared_examples 'unsuccessful discount creation' do |param|
        context "when #{param} is not passed" do
          it 'does not create a new discount' do
            expect { subject }.not_to change(Discount, :count)
          end

          it 'responds with 422 and an error message' do
            expect(subject.status).to eq 422
            expect(subject.body).not_to be_empty
          end
        end
      end

      context 'with invalid parameters' do
        %i[min_product_count rate].each do |param|
          it_behaves_like 'unsuccessful discount creation', param do
            let(:attributes) { common_attributes.except(param) }
          end
        end
      end

      context 'when the requested product does not exist' do
        include_context 'nonexistent product'
        it_behaves_like '"not found" response', Product
      end
    end
  end

  describe 'PUT /update' do
    let(:requested_product) { product }
    let!(:discount) { Discount.create!(attributes) }

    subject do
      put product_discount_url(requested_product, discount), params: { discount: new_attributes }, headers: {}, as: :json
      response
    end

    describe 'success' do
      context 'with valid parameters' do
        let(:new_attributes) { { min_product_count: 5, rate: 0.15 } }

        it 'responds with 200 and the updated discount' do
          expect(subject.status).to eq 200
          expect(JSON.parse(subject.body)).to match discount.reload.as_json
        end
      end
    end

    describe 'failure' do
      let(:new_attributes) { {} }

      context 'with invalid parameters' do
        context 'when no parameters passed' do
          it 'responds with 400 and an error message' do
            expect(subject.status).to eq 400
            expect(subject.body).to include 'param is missing'
          end
        end

        context 'when parameters contain wrong values' do
          shared_examples 'unsuccessful product update' do |param, value|
            let(:new_attributes) { { param => value } }

            it 'responds with 422 and an error message' do
              expect(subject.status).to eq 422
              expect(subject.body).to include 'Must be a number'
            end
          end

          %i[min_product_count rate].each do |param|
            ['', 'zero', nil, 0].each do |value|
              it_behaves_like 'unsuccessful product update', param, value
            end
          end
        end

        context 'when the discount belongs to another product' do
          include_context 'multiple products'
          let(:requested_product) { product2 }
          it_behaves_like '"not found" response', Discount
        end

        context 'when the requested product does not exist' do
          include_context 'nonexistent product'
          it_behaves_like '"not found" response', Product
        end
      end
    end
  end

  describe 'DELETE /destroy' do
    let(:requested_product) { product }
    let!(:discount) { Discount.create!(attributes) }

    subject do
      delete product_discount_url(requested_product, discount), headers: {}, as: :json
      response
    end

    describe 'success' do
      it 'destroys the requested discount and responds with 200' do
        expect { subject }.to change(Discount, :count).by(-1)
        expect(subject.status).to eq 204
      end
    end

    describe 'failure' do
      context 'when the requested product does not exist' do
        include_context 'nonexistent product'
        it_behaves_like '"not found" response', Product
      end
    end
  end
end
