module Aqua
  module Nodes
    class TermsStatsFacet
      attr_reader :key_field, :value_field, :size, :order, :filter

      def initialize(key_field, value_field, options = {})
        @key_field = key_field
        @value_field = value_field
        @size = options[:size]
        @order = options[:order]
        @filter = options[:filter]
      end
    end
  end
end
