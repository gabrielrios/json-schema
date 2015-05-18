require 'json-schema/attribute'

module JSON
  class Schema
    class TypeV4Attribute < Attribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        union = true
        types = current_schema.schema['type']
        if !types.is_a?(Array)
          types = [types]
          union = false
        end

        return if types.any? { |type| data_valid_for_type?(data, type) }

        types = types.map { |type| type.is_a?(String) ? type : '(schema)' }.join(', ')

        message, translation_key = if union
                                     ['one or more of the following types', 'json_schema_error_type_no_match']
                                   else
                                     ['the following type', 'json_schema_error_type_no_match_single']
                                   end

        fragment = build_fragment(fragments)
        property = fragments.last

        message = format(
          "The property '%s' of type %s did not match %s: %s",
          fragment,
          data.class,
          message,
          types
        )

        validation_error(processor, message, fragments, current_schema, self, options[:record_errors], translation_key, :types => types, :property => property)
      end
    end
  end
end
