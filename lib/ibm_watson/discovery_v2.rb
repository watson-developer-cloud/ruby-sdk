# frozen_string_literal: true

# (C) Copyright IBM Corp. 2019, 2020.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# IBM OpenAPI SDK Code Generator Version: 3.38.0-07189efd-20210827-205025
#
# IBM Watson&trade; Discovery is a cognitive search and content analytics engine that
# you can add to applications to identify patterns, trends and actionable insights to
# drive better decision-making. Securely unify structured and unstructured data with
# pre-enriched content, and use a simplified query language to eliminate the need for
# manual filtering of results.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

module IBMWatson
  ##
  # The Discovery V2 service.
  class DiscoveryV2 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    DEFAULT_SERVICE_NAME = "discovery"
    DEFAULT_SERVICE_URL = "https://api.us-south.discovery.watson.cloud.ibm.com"
    attr_accessor :version
    ##
    # @!method initialize(args)
    # Construct a new client for the Discovery service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] Release date of the version of the API you want to use. Specify dates in
    #   YYYY-MM-DD format. The current version is `2020-08-30`.
    # @option args service_url [String] The base service URL to use when contacting the service.
    #   The base service_url may differ between IBM Cloud regions.
    # @option args authenticator [Object] The Authenticator instance to be configured for this service.
    # @option args service_name [String] The name of the service to configure. Will be used as the key to load
    #   any external configuration, if applicable.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:service_url] = DEFAULT_SERVICE_URL
      defaults[:service_name] = DEFAULT_SERVICE_NAME
      defaults[:authenticator] = nil
      defaults[:version] = nil
      user_service_url = args[:service_url] unless args[:service_url].nil?
      args = defaults.merge(args)
      @version = args[:version]
      raise ArgumentError.new("version must be provided") if @version.nil?

      args[:authenticator] = IBMCloudSdkCore::ConfigBasedAuthenticatorFactory.new.get_authenticator(service_name: args[:service_name]) if args[:authenticator].nil?
      super
      @service_url = user_service_url unless user_service_url.nil?
    end

    #########################
    # Collections
    #########################

    ##
    # @!method list_collections(project_id:)
    # List collections.
    # Lists existing collections for the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_collections(project_id:)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_collections")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/collections" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method create_collection(project_id:, name:, description: nil, language: nil, enrichments: nil)
    # Create a collection.
    # Create a new collection in the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param name [String] The name of the collection.
    # @param description [String] A description of the collection.
    # @param language [String] The language of the collection.
    # @param enrichments [Array[CollectionEnrichment]] An array of enrichments that are applied to this collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_collection(project_id:, name:, description: nil, language: nil, enrichments: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("name must be provided") if name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "create_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description,
        "language" => language,
        "enrichments" => enrichments
      }

      method_url = "/v2/projects/%s/collections" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_collection(project_id:, collection_id:)
    # Get collection.
    # Get details about the specified collection.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_collection(project_id:, collection_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/collections/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method update_collection(project_id:, collection_id:, name: nil, description: nil, enrichments: nil)
    # Update a collection.
    # Updates the specified collection's name, description, and enrichments.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @param name [String] The name of the collection.
    # @param description [String] A description of the collection.
    # @param enrichments [Array[CollectionEnrichment]] An array of enrichments that are applied to this collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_collection(project_id:, collection_id:, name: nil, description: nil, enrichments: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "update_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description,
        "enrichments" => enrichments
      }

      method_url = "/v2/projects/%s/collections/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_collection(project_id:, collection_id:)
    # Delete a collection.
    # Deletes the specified collection from the project. All documents stored in the
    #   specified collection and not shared is also deleted.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @return [nil]
    def delete_collection(project_id:, collection_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/collections/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end
    #########################
    # Queries
    #########################

    ##
    # @!method query(project_id:, collection_ids: nil, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, _return: nil, offset: nil, sort: nil, highlight: nil, spelling_suggestions: nil, table_results: nil, suggested_refinements: nil, passages: nil)
    # Query a project.
    # By using this method, you can construct queries. For details, see the [Discovery
    #   documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-query-concepts).
    #   The default query parameters are defined by the settings for this project, see the
    #   [Discovery
    #   documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-project-defaults)
    #   for an overview of the standard default settings, and see [the Projects API
    #   documentation](#create-project) for details about how to set custom default query
    #   settings.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_ids [Array[String]] A comma-separated list of collection IDs to be queried against.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param aggregation [String] An aggregation search that returns an exact answer by combining query search with
    #   filters. Useful for applications to build lists, tables, and time series. For a
    #   full list of possible aggregations, see the Query reference.
    # @param count [Fixnum] Number of results to return.
    # @param _return [Array[String]] A list of the fields in the document hierarchy to return. If this parameter is an
    #   empty list, then all fields are returned.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results.
    # @param sort [String] A comma-separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @param highlight [Boolean] When `true`, a highlight field is returned for each result which contains the
    #   fields which match the query with `<em></em>` tags around the matching query
    #   terms.
    # @param spelling_suggestions [Boolean] When `true` and the **natural_language_query** parameter is used, the
    #   **natural_language_query** parameter is spell checked. The most likely correction
    #   is returned in the **suggested_query** field of the response (if one exists).
    # @param table_results [QueryLargeTableResults] Configuration for table retrieval.
    # @param suggested_refinements [QueryLargeSuggestedRefinements] Configuration for suggested refinements. Available with Premium plans only.
    # @param passages [QueryLargePassages] Configuration for passage retrieval.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query(project_id:, collection_ids: nil, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, _return: nil, offset: nil, sort: nil, highlight: nil, spelling_suggestions: nil, table_results: nil, suggested_refinements: nil, passages: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "collection_ids" => collection_ids,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "aggregation" => aggregation,
        "count" => count,
        "return" => _return,
        "offset" => offset,
        "sort" => sort,
        "highlight" => highlight,
        "spelling_suggestions" => spelling_suggestions,
        "table_results" => table_results,
        "suggested_refinements" => suggested_refinements,
        "passages" => passages
      }

      method_url = "/v2/projects/%s/query" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_autocompletion(project_id:, prefix:, collection_ids: nil, field: nil, count: nil)
    # Get Autocomplete Suggestions.
    # Returns completion query suggestions for the specified prefix.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param prefix [String] The prefix to use for autocompletion. For example, the prefix `Ho` could
    #   autocomplete to `hot`, `housing`, or `how`.
    # @param collection_ids [Array[String]] Comma separated list of the collection IDs. If this parameter is not specified,
    #   all collections in the project are used.
    # @param field [String] The field in the result documents that autocompletion suggestions are identified
    #   from.
    # @param count [Fixnum] The number of autocompletion suggestions to return.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_autocompletion(project_id:, prefix:, collection_ids: nil, field: nil, count: nil)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("prefix must be provided") if prefix.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_autocompletion")
      headers.merge!(sdk_headers)
      collection_ids *= "," unless collection_ids.nil?

      params = {
        "version" => @version,
        "prefix" => prefix,
        "collection_ids" => collection_ids,
        "field" => field,
        "count" => count
      }

      method_url = "/v2/projects/%s/autocompletion" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method query_collection_notices(project_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, count: nil, offset: nil)
    # Query collection notices.
    # Finds collection-level notices (errors and warnings) that are generated when
    #   documents are ingested.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param count [Fixnum] Number of results to return. The maximum for the **count** and **offset** values
    #   together in any one query is **10000**.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results. The maximum for the **count** and **offset** values together in any
    #   one query is **10000**.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query_collection_notices(project_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, count: nil, offset: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "query_collection_notices")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "count" => count,
        "offset" => offset
      }

      method_url = "/v2/projects/%s/collections/%s/notices" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method query_notices(project_id:, filter: nil, query: nil, natural_language_query: nil, count: nil, offset: nil)
    # Query project notices.
    # Finds project-level notices (errors and warnings). Currently, project-level
    #   notices are generated by relevancy training.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param count [Fixnum] Number of results to return. The maximum for the **count** and **offset** values
    #   together in any one query is **10000**.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results. The maximum for the **count** and **offset** values together in any
    #   one query is **10000**.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query_notices(project_id:, filter: nil, query: nil, natural_language_query: nil, count: nil, offset: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "query_notices")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "count" => count,
        "offset" => offset
      }

      method_url = "/v2/projects/%s/notices" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_fields(project_id:, collection_ids: nil)
    # List fields.
    # Gets a list of the unique fields (and their types) stored in the the specified
    #   collections.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_ids [Array[String]] Comma separated list of the collection IDs. If this parameter is not specified,
    #   all collections in the project are used.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_fields(project_id:, collection_ids: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_fields")
      headers.merge!(sdk_headers)
      collection_ids *= "," unless collection_ids.nil?

      params = {
        "version" => @version,
        "collection_ids" => collection_ids
      }

      method_url = "/v2/projects/%s/fields" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Component settings
    #########################

    ##
    # @!method get_component_settings(project_id:)
    # List component settings.
    # Returns default configuration settings for components.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_component_settings(project_id:)
      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_component_settings")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/component_settings" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Documents
    #########################

    ##
    # @!method add_document(project_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
    # Add a document.
    # Add a document to a collection with optional metadata.
    #
    #   Returns immediately after the system has accepted the document for processing.
    #
    #     * The user must provide document content, metadata, or both. If the request is
    #   missing both document content and metadata, it is rejected.
    #
    #     * You can set the **Content-Type** parameter on the **file** part to indicate
    #   the media type of the document. If the **Content-Type** parameter is missing or is
    #   one of the generic media types (for example, `application/octet-stream`), then the
    #   service attempts to automatically detect the document's media type.
    #
    #     * The following field names are reserved and are filtered out if present after
    #   normalization: `id`, `score`, `highlight`, and any field with the prefix of: `_`,
    #   `+`, or `-`
    #
    #     * Fields with empty name values after normalization are filtered out before
    #   indexing.
    #
    #     * Fields that contain the following characters after normalization are filtered
    #   out before indexing: `#` and `,`
    #
    #     If the document is uploaded to a collection that shares its data with another
    #   collection, the **X-Watson-Discovery-Force** header must be set to `true`.
    #
    #   **Note:** You can assign an ID to a document that you add by appending the ID to
    #   the endpoint
    #   (`/v2/projects/{project_id}/collections/{collection_id}/documents/{document_id}`).
    #   If a document already exists with the specified ID, it is replaced.
    #
    #   **Note:** This operation works with a file upload collection. It cannot be used to
    #   modify a collection that crawls an external data source.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @param file [File] The content of the document to ingest. For maximum supported file size limits, see
    #   [the
    #   documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-collections#collections-doc-limits).
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected.
    #
    #
    #   Example:  ``` {
    #     "Creator": "Johnny Appleseed",
    #     "Subject": "Apples"
    #   } ```.
    # @param x_watson_discovery_force [Boolean] When `true`, the uploaded document is added to the collection even if the data for
    #   that collection is shared with other collections.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def add_document(project_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
        "X-Watson-Discovery-Force" => x_watson_discovery_force
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "add_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless file.nil?
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        filename = file.path if filename.nil? && file.respond_to?(:path)
        form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: filename)
      end

      form_data[:metadata] = HTTP::FormData::Part.new(metadata.to_s, content_type: "text/plain") unless metadata.nil?

      method_url = "/v2/projects/%s/collections/%s/documents" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method update_document(project_id:, collection_id:, document_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
    # Update a document.
    # Replace an existing document or add a document with a specified **document_id**.
    #   Starts ingesting a document with optional metadata.
    #
    #   If the document is uploaded to a collection that shares its data with another
    #   collection, the **X-Watson-Discovery-Force** header must be set to `true`.
    #
    #   **Note:** When uploading a new document with this method it automatically replaces
    #   any document stored with the same **document_id** if it exists.
    #
    #   **Note:** This operation only works on collections created to accept direct file
    #   uploads. It cannot be used to modify a collection that connects to an external
    #   source such as Microsoft SharePoint.
    #
    #   **Note:** If an uploaded document is segmented, all segments are overwritten, even
    #   if the updated version of the document has fewer segments.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @param file [File] The content of the document to ingest. For maximum supported file size limits, see
    #   [the
    #   documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-collections#collections-doc-limits).
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected.
    #
    #
    #   Example:  ``` {
    #     "Creator": "Johnny Appleseed",
    #     "Subject": "Apples"
    #   } ```.
    # @param x_watson_discovery_force [Boolean] When `true`, the uploaded document is added to the collection even if the data for
    #   that collection is shared with other collections.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_document(project_id:, collection_id:, document_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil, x_watson_discovery_force: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
        "X-Watson-Discovery-Force" => x_watson_discovery_force
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "update_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless file.nil?
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        filename = file.path if filename.nil? && file.respond_to?(:path)
        form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: filename)
      end

      form_data[:metadata] = HTTP::FormData::Part.new(metadata.to_s, content_type: "text/plain") unless metadata.nil?

      method_url = "/v2/projects/%s/collections/%s/documents/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(document_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_document(project_id:, collection_id:, document_id:, x_watson_discovery_force: nil)
    # Delete a document.
    # If the given document ID is invalid, or if the document is not found, then the a
    #   success response is returned (HTTP status code `200`) with the status set to
    #   'deleted'.
    #
    #   **Note:** This operation only works on collections created to accept direct file
    #   uploads. It cannot be used to modify a collection that connects to an external
    #   source such as Microsoft SharePoint.
    #
    #   **Note:** Segments of an uploaded document cannot be deleted individually. Delete
    #   all segments by deleting using the `parent_document_id` of a segment result.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @param x_watson_discovery_force [Boolean] When `true`, the uploaded document is added to the collection even if the data for
    #   that collection is shared with other collections.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_document(project_id:, collection_id:, document_id:, x_watson_discovery_force: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
        "X-Watson-Discovery-Force" => x_watson_discovery_force
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/collections/%s/documents/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(document_id)]

      response = request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
    #########################
    # Training data
    #########################

    ##
    # @!method list_training_queries(project_id:)
    # List training queries.
    # List the training queries for the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_training_queries(project_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_training_queries")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/training_data/queries" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_training_queries(project_id:)
    # Delete training queries.
    # Removes all training queries for the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @return [nil]
    def delete_training_queries(project_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_training_queries")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/training_data/queries" % [ERB::Util.url_encode(project_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end

    ##
    # @!method create_training_query(project_id:, natural_language_query:, examples:, filter: nil)
    # Create training query.
    # Add a query to the training data for this project. The query can contain a filter
    #   and natural language query.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param natural_language_query [String] The natural text query for the training query.
    # @param examples [Array[TrainingExample]] Array of training examples.
    # @param filter [String] The filter used on the collection before the **natural_language_query** is
    #   applied.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_training_query(project_id:, natural_language_query:, examples:, filter: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("natural_language_query must be provided") if natural_language_query.nil?

      raise ArgumentError.new("examples must be provided") if examples.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "create_training_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "natural_language_query" => natural_language_query,
        "examples" => examples,
        "filter" => filter
      }

      method_url = "/v2/projects/%s/training_data/queries" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_training_query(project_id:, query_id:)
    # Get a training data query.
    # Get details for a specific training data query, including the query string and all
    #   examples.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param query_id [String] The ID of the query used for training.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_training_query(project_id:, query_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_training_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/training_data/queries/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(query_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method update_training_query(project_id:, query_id:, natural_language_query:, examples:, filter: nil)
    # Update a training query.
    # Updates an existing training query and it's examples.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param query_id [String] The ID of the query used for training.
    # @param natural_language_query [String] The natural text query for the training query.
    # @param examples [Array[TrainingExample]] Array of training examples.
    # @param filter [String] The filter used on the collection before the **natural_language_query** is
    #   applied.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_training_query(project_id:, query_id:, natural_language_query:, examples:, filter: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      raise ArgumentError.new("natural_language_query must be provided") if natural_language_query.nil?

      raise ArgumentError.new("examples must be provided") if examples.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "update_training_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "natural_language_query" => natural_language_query,
        "examples" => examples,
        "filter" => filter
      }

      method_url = "/v2/projects/%s/training_data/queries/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(query_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_training_query(project_id:, query_id:)
    # Delete a training data query.
    # Removes details from a training data query, including the query string and all
    #   examples.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param query_id [String] The ID of the query used for training.
    # @return [nil]
    def delete_training_query(project_id:, query_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_training_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/training_data/queries/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(query_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end
    #########################
    # analyze
    #########################

    ##
    # @!method analyze_document(project_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil)
    # Analyze a Document.
    # Process a document and return it for realtime use. Supports JSON files only.
    #
    #   The document is processed according to the collection's configuration settings but
    #   is not stored in the collection.
    #
    #   **Note:** This method is supported on installed instances of Discovery only.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param collection_id [String] The ID of the collection.
    # @param file [File] The content of the document to ingest. For maximum supported file size limits, see
    #   [the
    #   documentation](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-collections#collections-doc-limits).
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected.
    #
    #
    #   Example:  ``` {
    #     "Creator": "Johnny Appleseed",
    #     "Subject": "Apples"
    #   } ```.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def analyze_document(project_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "analyze_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless file.nil?
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        filename = file.path if filename.nil? && file.respond_to?(:path)
        form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: filename)
      end

      form_data[:metadata] = HTTP::FormData::Part.new(metadata.to_s, content_type: "text/plain") unless metadata.nil?

      method_url = "/v2/projects/%s/collections/%s/analyze" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(collection_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end
    #########################
    # enrichments
    #########################

    ##
    # @!method list_enrichments(project_id:)
    # List Enrichments.
    # Lists the enrichments available to this project. The *Part of Speech* and
    #   *Sentiment of Phrases* enrichments might be listed, but are reserved for internal
    #   use only.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_enrichments(project_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_enrichments")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/enrichments" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method create_enrichment(project_id:, enrichment:, file: nil)
    # Create an enrichment.
    # Create an enrichment for use with the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param enrichment [CreateEnrichment] Information about a specific enrichment.
    # @param file [File] The enrichment file to upload.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_enrichment(project_id:, enrichment:, file: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("enrichment must be provided") if enrichment.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "create_enrichment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:enrichment] = HTTP::FormData::Part.new(enrichment.to_s, content_type: "application/json")

      unless file.nil?
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        form_data[:file] = HTTP::FormData::File.new(file, content_type: "application/octet-stream", filename: file.respond_to?(:path) ? file.path : nil)
      end

      method_url = "/v2/projects/%s/enrichments" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_enrichment(project_id:, enrichment_id:)
    # Get enrichment.
    # Get details about a specific enrichment.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param enrichment_id [String] The ID of the enrichment.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_enrichment(project_id:, enrichment_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("enrichment_id must be provided") if enrichment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_enrichment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/enrichments/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(enrichment_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method update_enrichment(project_id:, enrichment_id:, name:, description: nil)
    # Update an enrichment.
    # Updates an existing enrichment's name and description.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param enrichment_id [String] The ID of the enrichment.
    # @param name [String] A new name for the enrichment.
    # @param description [String] A new description for the enrichment.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_enrichment(project_id:, enrichment_id:, name:, description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("enrichment_id must be provided") if enrichment_id.nil?

      raise ArgumentError.new("name must be provided") if name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "update_enrichment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description
      }

      method_url = "/v2/projects/%s/enrichments/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(enrichment_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_enrichment(project_id:, enrichment_id:)
    # Delete an enrichment.
    # Deletes an existing enrichment from the specified project.
    #
    #   **Note:** Only enrichments that have been manually created can be deleted.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param enrichment_id [String] The ID of the enrichment.
    # @return [nil]
    def delete_enrichment(project_id:, enrichment_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      raise ArgumentError.new("enrichment_id must be provided") if enrichment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_enrichment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s/enrichments/%s" % [ERB::Util.url_encode(project_id), ERB::Util.url_encode(enrichment_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end
    #########################
    # projects
    #########################

    ##
    # @!method list_projects
    # List projects.
    # Lists existing projects for this instance.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_projects
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "list_projects")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects"

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method create_project(name:, type:, default_query_parameters: nil)
    # Create a Project.
    # Create a new project for this instance.
    # @param name [String] The human readable name of this project.
    # @param type [String] The type of project.
    #
    #   The `content_intelligence` type is a *Document Retrieval for Contracts* project
    #   and the `other` type is a *Custom* project.
    #
    #   The `content_mining` and `content_intelligence` types are available with Premium
    #   plan managed deployments and installed deployments only.
    # @param default_query_parameters [DefaultQueryParams] Default query parameters for this project.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_project(name:, type:, default_query_parameters: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("name must be provided") if name.nil?

      raise ArgumentError.new("type must be provided") if type.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "create_project")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "type" => type,
        "default_query_parameters" => default_query_parameters
      }

      method_url = "/v2/projects"

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_project(project_id:)
    # Get project.
    # Get details on the specified project.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_project(project_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "get_project")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method update_project(project_id:, name: nil)
    # Update a project.
    # Update the specified project's name.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @param name [String] The new name to give this project.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_project(project_id:, name: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "update_project")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name
      }

      method_url = "/v2/projects/%s" % [ERB::Util.url_encode(project_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_project(project_id:)
    # Delete a project.
    # Deletes the specified project.
    #
    #   **Important:** Deleting a project deletes everything that is part of the specified
    #   project, including all collections.
    # @param project_id [String] The ID of the project. This information can be found from the *Integrate and
    #   Deploy* page in Discovery.
    # @return [nil]
    def delete_project(project_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("project_id must be provided") if project_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_project")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/projects/%s" % [ERB::Util.url_encode(project_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end
    #########################
    # userData
    #########################

    ##
    # @!method delete_user_data(customer_id:)
    # Delete labeled data.
    # Deletes all data associated with a specified customer ID. The method has no effect
    #   if no data is associated with the customer ID.
    #
    #   You associate a customer ID with data by passing the **X-Watson-Metadata** header
    #   with a request that passes data. For more information about personal data and
    #   customer IDs, see [Information
    #   security](https://cloud.ibm.com/docs/discovery-data?topic=discovery-data-information-security#information-security).
    #
    #
    #   **Note:** This method is only supported on IBM Cloud instances of Discovery.
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("customer_id must be provided") if customer_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V2", "delete_user_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "customer_id" => customer_id
      }

      method_url = "/v2/user_data"

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
      )
      nil
    end
  end
end
