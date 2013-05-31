module Aqua
  module Nodes
    class Missing
      attr_reader :field_name, :existence, :null_value
      
      def initialize(field_name, existence = true, null_value = true)
        @field_name = field_name
        @existence = existence
        @null_value = null_value
      end
    end
  end
end
