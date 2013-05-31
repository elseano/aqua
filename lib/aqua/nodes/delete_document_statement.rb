
module Aqua
  module Nodes
    class DeleteDocumentStatement

      attr_reader :index_name, :document_type, :document_id

      def initialize(index_name, document_type, document_id)
        @index_name = index_name
        @document_type = document_type
        @document_id = document_id
      end

    end
  end
end
