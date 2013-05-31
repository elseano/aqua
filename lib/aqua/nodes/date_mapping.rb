module Aqua
  module Nodes
    class DateMapping < Mapping
      def initialize(field_name, options = {})
        super(field_name, "date", options)
      end
    end
  end
end
