module Aqua
  class MappingManager

    attr_reader :index_name, :document_type, :fields

    def initialize(index_name, document_type)
      @index_name, @document_type = index_name, document_type
      @fields = []
    end

    def <<(node)
      @fields ||= []
      @fields << node
    end

    def keys
      @fields.collect(&:field_name)
    end

    def save
      statement = Apollo::Search::Nodes::MappingStatement.new(@index_name, @document_type, @fields)

      Apollo::Search.connection.execute(statement)
    end

  end
end
