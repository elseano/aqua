module Aqua
  module Nodes
    class StringMapping < Mapping
      def initialize(field_name, options = {})
        super(field_name, "string", options)
      end
    end
  end
end
