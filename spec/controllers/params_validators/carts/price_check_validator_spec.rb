require 'rails_helper'

RSpec.describe ParamValidators::Cart::PriceCheckValidator do
  let(:instance) { described_class.new(cart_params) }

  describe '#initialize' do
    subject { instance }

    context 'when receives an ActionController::Parameters instance' do
      let(:cart_params) { ActionController::Parameters.new }

      it 'converts it to a Hash and stores in an instance variable' do
        expect(subject.instance_variable_get(:@params)).to be_a Hash
      end
    end

    context 'when receives anything else' do
      let(:cart_params) { 'abracadabra' }

      it 'raises ParamsInvalid error' do
        expect { subject }.to raise_error ParamValidators::Cart::Errors::ParamsInvalid
      end
    end
  end

  describe '#validate!' do
    let(:cart_params) { ActionController::Parameters.new(mug: 1, PEN: '2', fog: 'one', mAn: 1.5, can: [], cat: -1, dog: 0) }

    subject { instance.validate! }

    context 'when there are acceptable <product> => <quantity> pairs' do
      it 'returns a hash with keys in uppercase and integer values' do
        expect(subject).to eq('MUG' => 1, 'PEN' => 2, 'MAN' => 1)
      end
    end

    context 'when there are incorrect <product> => <quantity> pairs only' do
      let(:cart_params) { ActionController::Parameters.new(can: [], cat: -1, dog: 0) }

      it 'raises ParamsInvalid error' do
        expect { subject }.to raise_error ParamValidators::Cart::Errors::ParamsInvalid
      end
    end
  end
end
