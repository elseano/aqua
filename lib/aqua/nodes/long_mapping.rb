module Aqua
  module Nodes
    class LongMapping < Mapping
      def initialize(field_name, options = {})
        super(field_name, "long", options)
      end
    end
  end
end
