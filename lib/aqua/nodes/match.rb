module Aqua
  module Nodes
    class Match
      attr_reader :field_name, :value
      
      def initialize(field_name, value)
        @field_name = field_name
        @value = value
      end
    end
  end
end
