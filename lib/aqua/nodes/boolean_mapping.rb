module Aqua
  module Nodes
    class BooleanMapping < Mapping
      def initialize(field_name, options = {})
        super(field_name, "boolean", options)
      end
    end
  end
end