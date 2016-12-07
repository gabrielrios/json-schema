require 'json-schema/attribute'

module JSON
  class Schema
    class DateTimeV4Format < FormatAttribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        return unless data.is_a?(String)
        DateTime.rfc3339(data)
      rescue ArgumentError
        error_message = "The property '#{build_fragment(fragments)}' must be a valid RFC3339 date/time string"
        validation_error(processor, error_message, fragments, current_schema, self, options[:record_errors], 'json_schema_error_date_time_format', :property => fragments.last)
      end
    end
  end
end
