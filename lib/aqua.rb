require "aqua/version"
require 'faraday'

module Aqua
  class << self
    attr_accessor :connection
  end

  require 'visitors/visitor'

  require 'node_collection'
  require 'index'
  require 'mapping_manager'

  # Connections
  require 'connections/elastic_search'
  require 'visitors/to_elasticsearch'

  # Search documents
  require 'nodes/query_statement'
  require 'nodes/terms'
  require 'nodes/match_all'
  require 'nodes/match'
  require 'nodes/prefix'
  require 'nodes/term'
  require 'nodes/not'
  require 'nodes/and'
  require 'nodes/or'
  require 'nodes/range'
  require 'nodes/exists'
  require 'nodes/missing'
  require 'nodes/text'
  require 'nodes/order'

  # Facets
  require 'nodes/date_histogram_facet'
  require 'nodes/statistical_facet'
  require 'nodes/terms_stats_facet'
  require 'nodes/terms_facet'
  require 'nodes/range_facet'
  require 'nodes/histogram_facet'
  require 'nodes/geo_distance_facet'
  require 'nodes/facet_list'
  require 'nodes/named_facet'

  # Mapping Documents
  require 'nodes/flush_statement'
  require 'nodes/index_exists_statement'
  require 'nodes/create_index_statement'
  require 'nodes/delete_document_statement'
  require 'nodes/mapping_statement'
  require 'nodes/document_statement'
  require 'nodes/mapping'
  require 'nodes/date_mapping'
  require 'nodes/double_mapping'
  require 'nodes/integer_mapping'
  require 'nodes/string_mapping'
  require 'nodes/boolean_mapping'
  require 'nodes/object_mapping'
  require 'nodes/long_mapping'
  require 'nodes/multi_field_mapping'
end
