module Aqua
  module Nodes
    class Not
      attr_reader :expr
      
      def initialize(expr)
        @expr = expr
      end
    end
  end
end
