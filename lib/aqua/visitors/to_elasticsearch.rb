module Aqua
  module Visitors
    class ToElasticsearch < Visitor
      
      private

      def visit_Apollo_Search_Nodes_FacetList(o)
        facets = {}
        o.nodes.each do |node|
          facets.merge!(visit(node))
        end
        facets          
      end

      def visit_Apollo_Search_Nodes_NamedFacet(o)
        {
          o.name => visit(o.expr)
        }
      end

      def visit_Apollo_Search_Nodes_StatisticalFacet(o)
        r = Hash.new
        r["field"] = o.field_name
        r["facet_filter"] = accept(o.filter) if o.filter

        {
          "statistical" => r
        }
      end

      def visit_Apollo_Search_Nodes_RangeFacet(o)
        r = Hash.new
        r["field"] = o.field_name
        r["ranges"] = o.ranges.nodes.collect { |node| accept(node) }
        r["facet_filter"] = accept(o.filter) if o.filter

        {
          "range" => r
        }
      end

      def visit_Apollo_Search_Nodes_RangeFacetRange(o)
        r = Hash.new
        r["from"] = o.from if o.from
        r["to"] = o.to if o.to
        r
      end

      def visit_Apollo_Search_Nodes_GeoDistanceFacet(o)
        r = Hash.new
        r[o.field_name] = { "lat" => o.lat, "long" => o.long }
        r["value_field"] = o.value_field if o.value_field
        r["ranges"] = o.ranges.nodes.collect { |node| accept(node) } if o.ranges
        r["facet_filter"] = accept(o.filter) if o.filter

        {
          "geo_distance" => r
        }
      end

      def visit_Apollo_Search_Nodes_TermsFacet(o)
        r = Hash.new
        r["field"] = o.field_name
        r["size"] = o.size if o.size
        r["order"] = o.order if o.order
        r["exclude"] = Array.wrap(o.exclude) if o.exclude
        r["all_terms"] = o.all_terms unless o.all_terms.nil?
        r["facet_filter"] = accept(o.filter) if o.filter

        {
          "terms" => r
        }
      end

      def visit_Apollo_Search_Nodes_TermsStatsFacet(o)
        r = Hash.new
        r["key_field"] = o.key_field
        r["value_field"] = o.value_field
        r["size"] = o.size if o.size
        r["order"] = o.order if o.order
        r["facet_filter"] = accept(o.filter) if o.filter

        {
          "terms_stats" => r
        }
      end

      def visit_Apollo_Search_Nodes_MultiFieldMapping(o)
        fields = {}
        o.nodes.each do |node|
          fields.merge!(visit(node))
        end

        {
          o.field_name => {
            'type' => "multi_field",
            'fields' => fields
          }
        }
      end

      def visit_Apollo_Search_Nodes_DocumentStatement(o)
        fields = {}
        o.fields.each do |field|
          fields.merge!( { field[0] => field[1] } )
        end

        fields["_id"] = o.document_id if o.document_id

        fields
      end

      def visit_Apollo_Search_Nodes_MappingStatement(o)
        fields = {}
        o.nodes.each do |node|
          fields.merge!(accept(node))
        end

        {
          o.document_type => {
            "properties" => fields
          }
        }
      end

      def visit_Apollo_Search_Nodes_ObjectMapping(o)
        properties = {}
        o.nodes.each do |node|
          properties.merge!(accept(node))
        end

        {
          o.field_name => { "type" => "object", "properties" => properties }
        }
      end

      def visit_Apollo_Search_Nodes_Mapping(o)
        options = o.options
        case options.delete(:analysis)
        when true then options[:index] = "analyzed"
        when false then options[:index] = "not_analyzed"
        end

        {
          o.field_name => { "type" => o.field_type }.merge(options.stringify_keys)
        }
      end

      def visit_Apollo_Search_Nodes_MatchAll(o)
        {
          "match_all" => {}
        }
      end

      def visit_Apollo_Search_Nodes_CreateIndexStatement(o)
        nil
      end

      def visit_Apollo_Search_Nodes_QueryStatement(o)
        query = {}
        query["query"] = {
          "filtered" => {
            "query" => visit(o.query || Apollo::Search::Nodes::MatchAll.new),
          }
        }
          
        query["query"]["filtered"]["filter"] = visit(o.filter) if o.filter && o.filter.nodes.length > 0
        query["facets"] = visit(o.facets) if o.facets && o.facets.nodes.length > 0
        query["sort"] = o.orders.collect { |order| visit(order) } if o.orders
        query
      end

      def visit_Apollo_Search_Nodes_Order(o)
        {
          o.field_name => { "order" => o.direction.to_s == "ascending" ? "asc" : "desc" }
        }
      end

      def visit_Apollo_Search_Nodes_DateHistogramFacet(o)
        result = {
          "interval" => o.interval
        }

        if o.value_field
          result["key_field"] = o.key_field
          result["value_field"] = o.value_field if o.value_field
        else
          result["field"] = o.key_field
        end

        result["facet_filter"] = accept(o.filter) if o.filter
        result["time_zone"] = o.time_zone if o.time_zone

        {
          "date_histogram" => result
        }
      end

      def visit_Apollo_Search_Nodes_HistogramFacet(o)
        result = Hash.new
        result["interval"] = o.interval if o.interval
        result["time_interval"] = o.time_interval if o.time_interval

        if o.value_field
          result["key_field"] = o.key_field
          result["value_field"] = o.value_field if o.value_field
        else
          result["field"] = o.key_field
        end

        result["facet_filter"] = accept(o.filter) if o.filter

        {
          "histogram" => result
        }
      end

      def visit_Apollo_Search_Nodes_Match(o)
        {
          "match" => {
            o.field_name => o.value
          }
        }
      end

      def visit_Apollo_Search_Nodes_Prefix(o)
        {
          "prefix" => {
            o.field_name => o.value
          }
        }
      end

      def visit_Apollo_Search_Nodes_Term(o)
        {
          "term" => {
            o.field_name => o.value
          }
        }
      end

      def visit_Apollo_Search_Nodes_Text(o)
        {
          "text" => {
            o.field_name => o.value
          }
        }
      end

      def visit_Apollo_Search_Nodes_Terms(o)
        {
          "terms" => {
            o.field_name => o.values
          }
        }
      end

      def visit_Apollo_Search_Nodes_Not(o)
        {
          "not" => visit(o.expr)
        }
      end

      def visit_Apollo_Search_Nodes_And(o)
        if o.nodes.length == 0
          visit(Nodes::MatchAll.new)
        elsif o.nodes.length == 1
          visit(o.nodes.first)
        else
          {
            "and" => o.nodes.collect { |expr| visit(expr) }
          }
        end
      end

      def visit_Apollo_Search_Nodes_Or(o)
        {
          "or" => o.nodes.collect { |expr| visit(expr) }
        }
      end

      def visit_Apollo_Search_Nodes_Exists(o)
        {
          "exists" => {
            "field" => o.field_name
          }
        }
      end

      def visit_Apollo_Search_Nodes_Missing(o)
        {
          "missing" => {
            "field" => o.field_name,
            "existence" => o.existence,
            "null_value" => o.null_value
          }
        }
      end

      def visit_Apollo_Search_Nodes_Range(o)
        if o.lower_value && o.upper_value
          {
            "range" => {
              o.field_name => {
                "from" => o.lower_value,
                "to" => o.upper_value,
                "include_lower" => o.include_lower,
                "include_upper" => o.include_upper
              }
            }
          }
        elsif o.lower_value
          {
            "range" => {
              o.field_name => {
                "from" => o.lower_value,
                "include_lower" => o.include_lower
              }
            }
          }
        elsif o.upper_value
          {
            "range" => {
              o.field_name => {
                "to" => o.upper_value,
                "include_upper" => o.include_upper
              }
            }
          }
        end
      end

    end
  end
end
