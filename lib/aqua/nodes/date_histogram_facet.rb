module Aqua
  module Nodes
    class DateHistogramFacet
      attr_reader :key_field, :value_field, :interval, :time_zone, :filter
      
      def initialize(key_field, interval, options = {})
        raise ArgumentError, "Options can only contain value_field, time_zone, or filter" if (options.keys - [:value_field, :time_zone, :filter]).length > 0

        @key_field = key_field
        @interval = interval
        @value_field = options[:value_field]
        @time_zone = options[:time_zone]
        @filter = options[:filter]
      end
    end
  end
end
