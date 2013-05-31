module Aqua
  module Nodes
    class MultiFieldMapping < Mapping
      attr_reader :nodes
      
      def initialize(field_name, options = {})
        super(field_name, "multi_field", options)
        @nodes = []
      end

      def <<(node)
        @nodes << node
      end
    end
  end
end
