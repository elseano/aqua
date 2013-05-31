
module Aqua
  module Nodes
    class DocumentStatement

      attr_reader :index_name, :document_type, :fields, :document_id

      def initialize(index_name, document_type, document_id)
        @index_name = index_name
        @document_type = document_type
        @document_id = document_id
        @fields = []
      end

      def add_field(name, value)
        @fields << [name, value]
      end

    end
  end
end
