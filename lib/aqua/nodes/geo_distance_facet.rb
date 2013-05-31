module Aqua
  module Nodes
    class GeoDistanceFacet
      attr_reader :field_name, :lat, :long, :ranges, :filter, :value_field

      def initialize(field_name, lat, long, options = {})
        @field_name = field_name
        @lat = lat
        @long = long

        @value_field = options[:value_field]

        if ranges = options[:ranges]
          @ranges = ranges.is_a?(NodeCollection) ? ranges : NodeCollection.new(ranges)
        end

        @filter = options[:filter]
      end
    end
  end
end
