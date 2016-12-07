require 'json-schema/attribute'

module JSON
  class Schema
    class DivisibleByAttribute < Attribute
      def self.keyword
        'divisibleBy'
      end

      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        return unless data.is_a?(Numeric)

        factor = current_schema.schema[keyword]

        fragment = build_fragment(fragments)
        if factor == 0 || factor == 0.0 || (BigDecimal.new(data.to_s) % BigDecimal.new(factor.to_s)).to_f != 0
          message = "The property '#{fragment}' was not divisible by #{factor}"
          validation_error(processor, message, fragments, current_schema, self, options[:record_errors], translation_key, :factor => factor, :property => fragments.last)
        end
      end

      def self.translation_key
        "json_schema_error_#{keyword}"
      end
    end
  end
end
