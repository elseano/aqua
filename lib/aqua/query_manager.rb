module Aqua
  class QueryManager

    attr_reader :query, :filter
    attr_accessor :limit, :offset

    def initialize
      @query = Nodes::And.new
      @filter = Nodes::And.new
      @limit = nil
      @offset = nil
    end

    def to_elastic_search
      Visitors::ToElasticsearch.new.accept(self)
    end

    def execute
      
    end
  end
end
