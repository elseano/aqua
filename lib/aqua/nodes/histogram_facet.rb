module Aqua
  module Nodes
    class HistogramFacet
      attr_reader :key_field, :value_field, :interval, :time_interval, :filter
      
      def initialize(key_field, interval, options = {})
        raise ArgumentError, "Options can only contain value_field, or filter" if (options.keys - [:value_field, :filter]).length > 0

        @key_field = key_field
        if interval.is_a?(String)
          @time_interval = interval
        else
          @interval = interval
        end
        
        @value_field = options[:value_field]
        @filter = options[:filter]
      end
    end
  end
end
