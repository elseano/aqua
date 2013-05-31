module Aqua
  module Nodes
    class ObjectMapping < NodeCollection
      attr_reader :field_name

      def initialize(field_name, *nodes)
        super(nodes)
        @field_name = field_name
      end
    end
  end
end
