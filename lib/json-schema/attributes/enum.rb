require 'json-schema/attribute'

module JSON
  class Schema
    class EnumAttribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        enum = current_schema.schema['enum']
        return if enum.include?(data)

        values = enum.map { |val|
          case val
          when nil   then 'null'
          when Array then 'array'
          when Hash  then 'object'
          else val.to_s
          end
        }.join(', ')

        fragment = build_fragment(fragments)
        message = "The property '#{fragment}' value #{data.inspect} did not match one of the following values: #{values}"
        validation_error(processor, message, fragments, current_schema, self, options[:record_errors], 'json_schema_error_enum', :values => values, :property => fragments.last)
      end
    end
  end
end
