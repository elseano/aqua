
module Aqua
  module Nodes
    class CreateIndexStatement

      attr_reader :index_name

      def initialize(index_name)
        @index_name = index_name
      end

    end
  end
end
