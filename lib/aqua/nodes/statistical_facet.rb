module Aqua
  module Nodes
    class StatisticalFacet
      attr_reader :field_name, :filter

      def initialize(field_name, options = {})
        @field_name = field_name
        @filter = options[:filter]
      end
    end
  end
end
