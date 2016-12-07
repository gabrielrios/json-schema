require 'json-schema/attribute'
require 'json-schema/errors/uri_error'

module JSON
  class Schema
    class UriFormat < FormatAttribute
      def self.validate(current_schema, data, fragments, processor, validator, options = {})
        return unless data.is_a?(String)
        error_message = "The property '#{build_fragment(fragments)}' must be a valid URI"
        begin
          JSON::Util::URI.parse(data)
        rescue JSON::Schema::UriError
          validation_error(processor, error_message, fragments, current_schema, self, options[:record_errors], 'json_schema_error_uri_format', :property => fragments.last)
        end
      end
    end
  end
end
