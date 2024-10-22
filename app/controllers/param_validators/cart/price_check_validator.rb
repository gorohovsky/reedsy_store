module ParamValidators
  module Cart
    class PriceCheckValidator
      include Errors

      def initialize(cart_params)
        @params = cart_params.to_unsafe_h
      rescue NoMethodError
        raise ParamsInvalid
      end

      def validate!
        transformed_params.presence || raise(ParamsInvalid)
      end

      private

      def transformed_params
        @params.each_with_object({}) do |(product_code, product_count), result|
          count = safe_to_i(product_count)
          result[product_code.upcase] = count if count.positive?
        end
      end

      def safe_to_i(object)
        object.to_i
      rescue NoMethodError
        0
      end
    end
  end
end
