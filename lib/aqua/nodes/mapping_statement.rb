
module Aqua
  module Nodes
    class MappingStatement < NodeCollection

      attr_reader :index_name, :document_type

      def initialize(index_name, document_type, *args)
        @index_name = index_name
        @document_type = document_type
        super(*args)
      end

    end
  end
end
