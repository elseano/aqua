module Aqua
  module Nodes
    class QueryStatement

      attr_accessor :indicies
      attr_accessor :query, :filter
      attr_accessor :limit, :offset, :fields, :facets, :orders

      def initialize
        @query = nil
        @filter = nil
        @limit = nil
        @offset = nil
        @fields = []
        @indicies = []
        @facets = nil
        @orders = []
      end

    end
  end
end
