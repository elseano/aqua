module Aqua
  module Nodes
    class Mapping
      DEFAULT_MAPPINGS = {
        include_in_all: false
      }

      attr_reader :field_name, :field_type, :options

      def initialize(field_name, field_type, options = {})
        @field_name, @field_type = field_name, field_type
        @options = DEFAULT_MAPPINGS.merge(options)
      end
    end
  end
end
