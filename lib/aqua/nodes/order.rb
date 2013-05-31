module Aqua
  module Nodes
    class Order
      attr_reader :field_name, :direction
      
      def initialize(field_name, direction)
        @field_name = field_name
        @direction = direction
      end
    end
  end
end
