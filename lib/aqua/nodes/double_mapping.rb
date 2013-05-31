module Aqua
  module Nodes
    class DoubleMapping < Mapping
      def initialize(field_name, options = {})
        super(field_name, "double", options)
      end
    end
  end
end
