require "aqua/version"
require 'faraday'

module Aqua
  class << self
    attr_accessor :connection
  end

  require 'aqua/visitors/visitor'

  require 'aqua/node_collection'
  require 'aqua/index'
  require 'aqua/mapping_manager'
  require 'aqua/query_manager'

  # Connections
  require 'aqua/connections/elastic_search'
  require 'aqua/visitors/to_elasticsearch'

  # Search documents
  require 'aqua/nodes/query_statement'
  require 'aqua/nodes/terms'
  require 'aqua/nodes/match_all'
  require 'aqua/nodes/match'
  require 'aqua/nodes/prefix'
  require 'aqua/nodes/term'
  require 'aqua/nodes/not'
  require 'aqua/nodes/and'
  require 'aqua/nodes/or'
  require 'aqua/nodes/range'
  require 'aqua/nodes/exists'
  require 'aqua/nodes/missing'
  require 'aqua/nodes/text'
  require 'aqua/nodes/order'

  # Facets
  require 'aqua/nodes/date_histogram_facet'
  require 'aqua/nodes/statistical_facet'
  require 'aqua/nodes/terms_stats_facet'
  require 'aqua/nodes/terms_facet'
  require 'aqua/nodes/range_facet'
  require 'aqua/nodes/histogram_facet'
  require 'aqua/nodes/geo_distance_facet'
  require 'aqua/nodes/facet_list'
  require 'aqua/nodes/named_facet'

  # Mapping Documents
  require 'aqua/nodes/flush_statement'
  require 'aqua/nodes/index_exists_statement'
  require 'aqua/nodes/create_index_statement'
  require 'aqua/nodes/delete_document_statement'
  require 'aqua/nodes/mapping_statement'
  require 'aqua/nodes/document_statement'
  require 'aqua/nodes/mapping'
  require 'aqua/nodes/date_mapping'
  require 'aqua/nodes/double_mapping'
  require 'aqua/nodes/integer_mapping'
  require 'aqua/nodes/string_mapping'
  require 'aqua/nodes/boolean_mapping'
  require 'aqua/nodes/object_mapping'
  require 'aqua/nodes/long_mapping'
  require 'aqua/nodes/multi_field_mapping'
end
