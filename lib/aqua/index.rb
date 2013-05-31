module Aqua
  class Index
    def initialize(name)
      @name = name
    end

    def create
      statement = Apollo::Search::Nodes::CreateIndexStatement.new(@name)
      execute(statement)
    end

    def url
      if Apollo::Search.connection.respond_to?(:make_url)
        Apollo::Search.connection.make_url(@name, nil)
      end
    end

    def delete_index!
      execute Apollo::Search::Nodes::DeleteIndexStatement.new(@name)
    end

    def delete_document(id, type = 'document')
      execute Apollo::Search::Nodes::DeleteDocumentStatement.new(@name, type, id)
    end

    def mapping(type = 'document')
      Apollo::Search::MappingManager.new(@name, type)
    end

    def flush
      execute Apollo::Search::Nodes::FlushStatement.new(@name)
    end

    def exists?
      execute Apollo::Search::Nodes::IndexExistsStatement.new(@name)
    end

    def store_document(values, type = 'document')
      values = values.stringify_keys
      
      id = values["_id"]
      statement = Apollo::Search::Nodes::DocumentStatement.new(@name, type, id)
      
      values.each do |key, value|
        statement.add_field(key, value)
      end

      execute(statement)
    end

    def query(type = "document")
      scope = Apollo::Search::QueryScope.new(@name)
      scope.types << type
      scope
    end

    private

    def execute(statement)
      Apollo::Search.connection.execute(statement)
    end

  end
end
