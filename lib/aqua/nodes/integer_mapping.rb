module Aqua
  module Nodes
    class IntegerMapping < Mapping
      def initialize(field_name, options = {})
        super(field_name, "integer", options)
      end
    end
  end
end
