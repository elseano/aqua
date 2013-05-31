module Aqua
  module Nodes
    class NamedFacet
      attr_reader :name, :expr

      def initialize(name, expr)
        @name = name
        @expr = expr
      end
    end
  end
end
