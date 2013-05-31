module Aqua
  module Nodes
    class TermsFacet
      attr_reader :field_name, :size, :order, :all_terms, :exclude, :filter

      def initialize(field_name, options = {})
        @field_name = field_name
        @size = options[:size]
        @order = options[:order]
        @all_terms = options[:all_terms]
        @exclude = options[:exclude]
        @filter = options[:filter]
      end
    end
  end
end
