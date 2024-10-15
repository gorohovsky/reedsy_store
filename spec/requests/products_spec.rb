require 'rails_helper'

RSpec.describe '/products', type: :request do
  describe 'GET /index' do
    let(:attributes) { { code: 'PEN', name: 'Reedsy Pen', price: 55.01 } }
    let!(:product) { Product.create! attributes }

    subject do
      get products_url, headers: {}, as: :json
      response
    end

    it 'renders a successful response' do
      expect(subject.status).to eq 200
      expect(JSON.parse(subject.body)[0]).to match product.as_json(except: %i[created_at updated_at])
    end
  end
end
