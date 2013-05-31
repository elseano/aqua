module Aqua
  module Nodes
    class RangeFacet
      attr_reader :field_name, :ranges, :filter

      def initialize(field_name, ranges, options = {})
        @field_name = field_name
        @ranges = ranges.is_a?(NodeCollection) ? ranges : NodeCollection.new(ranges)
        @filter = options[:filter]
      end
    end

    class RangeFacetRange
      attr_reader :from, :to

      def initialize(from, to)
        @from = from
        @to = to
      end
    end
  end
end
