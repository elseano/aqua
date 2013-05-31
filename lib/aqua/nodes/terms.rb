module Aqua
  module Nodes
    class Terms
      attr_reader :field_name, :values
      
      def initialize(field_name, *values)
        @field_name = field_name
        @values = values.flatten
      end
    end
  end
end
