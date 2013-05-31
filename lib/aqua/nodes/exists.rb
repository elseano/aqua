module Aqua
  module Nodes
    class Exists
      attr_reader :field_name
      
      def initialize(field_name)
        @field_name = field_name
      end
    end
  end
end
