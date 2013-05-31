
module Aqua
  module Nodes
    class IndexExistsStatement

      attr_reader :index_name

      def initialize(index_name)
        @index_name = index_name
      end

    end
  end
end
