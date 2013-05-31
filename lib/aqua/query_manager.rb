module Aqua
  class QueryManager

    def initialize
      @statement = Nodes::QueryStatement.new
      @statement.query ||= Nodes::And.new
    end

    def query
      @statement.query
    end

    def to_elastic_search
      Visitors::ToElasticsearch.new.accept(@statement)
    end

    def execute
      
    end
  end
end
