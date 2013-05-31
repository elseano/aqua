
module Aqua
  module Connections
    class ElasticSearch < Apollo::Search::Visitors::Visitor

      alias execute accept
      private :accept

      class Response < Struct.new(:body, :status, :headers)
      end

      class ElasticSearchError < StandardError
        attr_reader :error_class, :message 
        def initialize(error_class, message)
          @error_class = error_class
          @message = message
        end
      end

      attr_reader :url, :prefix

      def initialize(url, prefix = nil)
        @url, @prefix = url, prefix
      end

      def make_url(index, type = nil, document_id = nil)
        if document_id
          File.join(make_index_url(index, type), document_id)
        else
          make_index_url(index, type)
        end
      end

      private

      def make_payload(statement)
        Visitors::ToElasticsearch.new.accept(statement)
      end

      def make_index_url(index, type = nil)
        if type
          File.join(url, index, type)
        else
          File.join(url, index)
        end
      end

      def visit_Apollo_Search_Nodes_DeleteDocumentStatement(statement)
        url = make_index_url("#{prefix}#{statement.index_name}")

        result = ActiveSupport::Notifications.instrument("query.apollo", command: "delete", index: statement.index_name) do
          delete(url + "/#{statement.document_type}/#{statement.document_id}")
        end

        decode_response(result)

        return true
      rescue ElasticSearchError => ex
        return false if ex.error_class == "IndexMissingException"
        raise
      end

      def visit_Apollo_Search_Nodes_IndexExistsStatement(statement)
        url = make_index_url("#{prefix}#{statement.index_name}")

        result = ActiveSupport::Notifications.instrument("query.apollo", command: "exists", index: statement.index_name) do
          get(url + "/_settings", MultiJson.encode(Hash.new))
        end

        decode_response(result)

        return true
      rescue ElasticSearchError => ex
        return false if ex.error_class == "IndexMissingException"
        raise
      end

      def visit_Apollo_Search_Nodes_FlushStatement(statement)
        url = make_index_url("#{prefix}#{statement.index_name}")

        result = ActiveSupport::Notifications.instrument("query.apollo", command: "flush", index: statement.index_name) do
          post(url + "/_flush", MultiJson.encode(Hash.new))
        end

        result = decode_response(result)
        result["ok"] && result["acknowledged"]
      end

      def visit_Apollo_Search_Nodes_QueryStatement(statement)
        index_list = statement.indicies.collect { |name| "#{prefix}#{name}" }.join(",")
        doc_type = "document"

        url = make_index_url(index_list, doc_type) + "/_search"
        payload = make_payload(statement)

        response = ActiveSupport::Notifications.instrument("query.apollo", command: "query", json: payload, index: index_list, type: doc_type) do
          get(url, MultiJson.encode(payload))
        end

        decode_response(response)
      end

      def visit_Apollo_Search_Nodes_CreateIndexStatement(statement)
        url = make_index_url("#{prefix}#{statement.index_name}")
        payload = make_payload(statement)


        result = ActiveSupport::Notifications.instrument("query.apollo", command: "create", json: payload, index: statement.index_name) do
          post(url + "/", MultiJson.encode(payload))
        end

        result = decode_response(result)
        result["ok"] && result["acknowledged"]
      end

      def visit_Apollo_Search_Nodes_CountStatement(statement)
        
      end

      def visit_Apollo_Search_Nodes_DocumentStatement(statement)
        url = make_index_url("#{prefix}#{statement.index_name}", statement.document_type) + "/#{statement.document_id}"
        payload = make_payload(statement)

        result = ActiveSupport::Notifications.instrument("query.apollo", command: "store", json: payload, index: statement.index_name, type: statement.document_type) do
          post(url , MultiJson.encode(payload))
        end

        result = decode_response(result)
        result["ok"]
      end

      def visit_Apollo_Search_Nodes_MappingStatement(statement)
        url = make_index_url("#{prefix}#{statement.index_name}", statement.document_type)
        payload = make_payload(statement)

        result = ActiveSupport::Notifications.instrument("query.apollo", command: "map", json: payload, index: statement.index_name, type: statement.document_type) do
          put(url + "/_mapping", MultiJson.encode(payload))
        end

        result = decode_response(result)
        result["ok"] && result["acknowledged"]
      end

      # Connection essentials

      # Default middleware stack.
      DEFAULT_MIDDLEWARE = Proc.new do |builder|
        builder.adapter ::Faraday.default_adapter
      end

      # A customized stack of Faraday middleware that will be used to make each request.
      attr_accessor :faraday_middleware

      def get(url, data = nil)
        request(:get, url, data)
      end

      def post(url, data)
        request(:post, url, data)
      end

      def put(url, data)
        request(:put, url, data)
      end

      def delete(url, data = nil)
        request(:delete, url, data)
      end

      def head(url)
        request(:head, url)
      end

      def request(method, url, data = nil)
        conn = ::Faraday.new( &(faraday_middleware || DEFAULT_MIDDLEWARE) )
        response = conn.run_request(method, url, data, nil)
        Response.new(response.body, response.status, response.headers)
      end

      def decode_response(response)
        body = MultiJson.decode(response.body)
        if error_string = body["error"]
          error_class = error_string.match(/([A-Za-z]+)/).captures.first
          raise ElasticSearchError.new(error_class, error_string)
        end

        return body
      end
    end
  end
end
