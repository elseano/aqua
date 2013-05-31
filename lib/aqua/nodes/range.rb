module Aqua
  module Nodes
    class Range
      attr_reader :field_name, :lower_value, :upper_value, :include_lower, :include_upper
      
      def initialize(field_name, lower_value, upper_value, include_lower = false, include_upper = false)
        @field_name = field_name
        @lower_value = lower_value
        @upper_value = upper_value
        @include_upper = include_upper
        @include_lower = include_lower
      end
    end
  end
end
