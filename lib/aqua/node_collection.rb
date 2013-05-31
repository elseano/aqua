module Aqua
  class NodeCollection
    attr_reader :nodes

    def initialize(*nodes)
      @nodes = nodes.flatten
    end

    def <<(node)
      @nodes << node
    end

    def to_elastic_search
      visitor = Visitors::ToElasticsearch.new
      result = []

      @nodes.each do |node|
        result << visitor.accept(node)
      end

      result
    end
  end
end
