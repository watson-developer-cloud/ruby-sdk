# frozen_string_literal: true

# Copyright 2018 IBM All Rights Reserved.
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

# The IBM Watson&trade; Discovery Service is a cognitive search and content analytics
# engine that you can add to applications to identify patterns, trends and actionable
# insights to drive better decision-making. Securely unify structured and unstructured
# data with pre-enriched content, and use a simplified query language to eliminate the
# need for manual filtering of results.

require "json"
require_relative "./detailed_response"

require_relative "./watson_service"

module WatsonAPIs
  ##
  # The Discovery V1 service.
  class DiscoveryV1 < WatsonService
    ##
    # @!method initialize(args)
    # Construct a new client for the Discovery service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] The API version date to use with the service, in
    #   "YYYY-MM-DD" format. Whenever the API is changed in a backwards
    #   incompatible way, a new minor version of the API is released.
    #   The service uses the API version for the date you specify, or
    #   the most recent version before that date. Note that you should
    #   not programmatically specify the current date at runtime, in
    #   case the API has been updated since your application's release.
    #   Instead, specify a version date that is compatible with your
    #   application, and don't change it until your application is
    #   ready for a later version.
    # @option args url [String] The base url to use when contacting the service (e.g.
    #   "https://gateway.watsonplatform.net/discovery/api").
    #   The base url may differ between Bluemix regions.
    # @option args username [String] The username used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args password [String] The password used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args iam_api_key [String] An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # @option args iam_access_token [String] An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # @option args iam_url [String] An optional URL for the IAM service API. Defaults to
    #   'https://iam.ng.bluemix.net/identity/token'.
    def initialize(args)
      defaults = {}
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/discovery/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_api_key] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      super(
        vcap_services_name: "discovery",
        url: args[:url],
        username: args[:username],
        password: args[:password],
        iam_api_key: args[:iam_api_key],
        iam_access_token: args[:iam_access_token],
        iam_url: args[:iam_url],
        use_vcap_services: true
      )
      @version = args[:version]
    end
    #########################
    # Environments
    #########################

    ##
    # @!method create_environment(name:, description: nil, size: nil)
    # Create an environment.
    # Creates a new environment for private data. An environment must be created before
    #   collections can be created.
    #
    #   **Note**: You can create only one environment for private data per service
    #   instance. An attempt to create another environment results in an error.
    # @param name [String] Name that identifies the environment.
    # @param description [String] Description of the environment.
    # @param size [Fixnum] **Deprecated**: Size of the environment.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_environment(name:, description: nil, size: nil)
      raise ArgumentError("name must be provided") if name.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "name" => name,
        "description" => description,
        "size" => size
      }
      method_url = "/v1/environments"
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
    # @!method list_environments(name: nil)
    # List environments.
    # List existing environments for the service instance.
    # @param name [String] Show only the environment with the given name.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_environments(name: nil)
      headers = {
      }
      params = {
        "version" => @version,
        "name" => name
      }
      method_url = "/v1/environments"
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
    # @!method get_environment(environment_id:)
    # Get environment info.
    # @param environment_id [String] The ID of the environment.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_environment(environment_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s" % [url_encode(environment_id)]
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
    # @!method update_environment(environment_id:, name: nil, description: nil)
    # Update an environment.
    # Updates an environment. The environment's **name** and  **description** parameters
    #   can be changed. You must specify a **name** for the environment.
    # @param environment_id [String] The ID of the environment.
    # @param name [String] Name that identifies the environment.
    # @param description [String] Description of the environment.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def update_environment(environment_id:, name: nil, description: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "name" => name,
        "description" => description
      }
      method_url = "/v1/environments/%s" % [url_encode(environment_id)]
      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_environment(environment_id:)
    # Delete environment.
    # @param environment_id [String] The ID of the environment.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def delete_environment(environment_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s" % [url_encode(environment_id)]
      response = request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_fields(environment_id:, collection_ids:)
    # List fields across collections.
    # Gets a list of the unique fields (and their types) stored in the indexes of the
    #   specified collections.
    # @param environment_id [String] The ID of the environment.
    # @param collection_ids [Array[String]] A comma-separated list of collection IDs to be queried against.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_fields(environment_id:, collection_ids:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_ids must be provided") if collection_ids.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "collection_ids" => collection_ids.to_a
      }
      method_url = "/v1/environments/%s/fields" % [url_encode(environment_id)]
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
    # Configurations
    #########################

    ##
    # @!method create_configuration(environment_id:, name:, description: nil, conversions: nil, enrichments: nil, normalizations: nil, source: nil)
    # Add configuration.
    # Creates a new configuration.
    #
    #   If the input configuration contains the **configuration_id**, **created**, or
    #   **updated** properties, then they are ignored and overridden by the system, and an
    #   error is not returned so that the overridden fields do not need to be removed when
    #   copying a configuration.
    #
    #   The configuration can contain unrecognized JSON fields. Any such fields are
    #   ignored and do not generate an error. This makes it easier to use newer
    #   configuration files with older versions of the API and the service. It also makes
    #   it possible for the tooling to add additional metadata and information to the
    #   configuration.
    # @param environment_id [String] The ID of the environment.
    # @param name [String] The name of the configuration.
    # @param description [String] The description of the configuration, if available.
    # @param conversions [Conversions] The document conversion settings for the configuration.
    # @param enrichments [Array[Enrichment]] An array of document enrichment settings for the configuration.
    # @param normalizations [Array[NormalizationOperation]] Defines operations that can be used to transform the final output JSON into a
    #   normalized form. Operations are executed in the order that they appear in the
    #   array.
    # @param source [Source] Object containing source parameters for the configuration.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_configuration(environment_id:, name:, description: nil, conversions: nil, enrichments: nil, normalizations: nil, source: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("name must be provided") if name.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "name" => name,
        "description" => description,
        "conversions" => conversions,
        "enrichments" => enrichments,
        "normalizations" => normalizations,
        "source" => source
      }
      method_url = "/v1/environments/%s/configurations" % [url_encode(environment_id)]
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
    # @!method list_configurations(environment_id:, name: nil)
    # List configurations.
    # Lists existing configurations for the service instance.
    # @param environment_id [String] The ID of the environment.
    # @param name [String] Find configurations with the given name.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_configurations(environment_id:, name: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "name" => name
      }
      method_url = "/v1/environments/%s/configurations" % [url_encode(environment_id)]
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
    # @!method get_configuration(environment_id:, configuration_id:)
    # Get configuration details.
    # @param environment_id [String] The ID of the environment.
    # @param configuration_id [String] The ID of the configuration.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_configuration(environment_id:, configuration_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("configuration_id must be provided") if configuration_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/configurations/%s" % [url_encode(environment_id), url_encode(configuration_id)]
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
    # @!method update_configuration(environment_id:, configuration_id:, name:, description: nil, conversions: nil, enrichments: nil, normalizations: nil, source: nil)
    # Update a configuration.
    # Replaces an existing configuration.
    #     * Completely replaces the original configuration.
    #     * The **configuration_id**, **updated**, and **created** fields are accepted in
    #   the request, but they are ignored, and an error is not generated. It is also
    #   acceptable for users to submit an updated configuration with none of the three
    #   properties.
    #     * Documents are processed with a snapshot of the configuration as it was at the
    #   time the document was submitted to be ingested. This means that already submitted
    #   documents will not see any updates made to the configuration.
    # @param environment_id [String] The ID of the environment.
    # @param configuration_id [String] The ID of the configuration.
    # @param name [String] The name of the configuration.
    # @param description [String] The description of the configuration, if available.
    # @param conversions [Conversions] The document conversion settings for the configuration.
    # @param enrichments [Array[Enrichment]] An array of document enrichment settings for the configuration.
    # @param normalizations [Array[NormalizationOperation]] Defines operations that can be used to transform the final output JSON into a
    #   normalized form. Operations are executed in the order that they appear in the
    #   array.
    # @param source [Source] Object containing source parameters for the configuration.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def update_configuration(environment_id:, configuration_id:, name:, description: nil, conversions: nil, enrichments: nil, normalizations: nil, source: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("configuration_id must be provided") if configuration_id.nil?
      raise ArgumentError("name must be provided") if name.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "name" => name,
        "description" => description,
        "conversions" => conversions,
        "enrichments" => enrichments,
        "normalizations" => normalizations,
        "source" => source
      }
      method_url = "/v1/environments/%s/configurations/%s" % [url_encode(environment_id), url_encode(configuration_id)]
      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_configuration(environment_id:, configuration_id:)
    # Delete a configuration.
    # The deletion is performed unconditionally. A configuration deletion request
    #   succeeds even if the configuration is referenced by a collection or document
    #   ingestion. However, documents that have already been submitted for processing
    #   continue to use the deleted configuration. Documents are always processed with a
    #   snapshot of the configuration as it existed at the time the document was
    #   submitted.
    # @param environment_id [String] The ID of the environment.
    # @param configuration_id [String] The ID of the configuration.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def delete_configuration(environment_id:, configuration_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("configuration_id must be provided") if configuration_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/configurations/%s" % [url_encode(environment_id), url_encode(configuration_id)]
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
    # Test your configuration on a document
    #########################

    ##
    # @!method test_configuration_in_environment(environment_id:, configuration: nil, step: nil, configuration_id: nil, file: nil, metadata: nil, file_content_type: nil, filename: nil)
    # Test configuration.
    # Runs a sample document through the default or your configuration and returns
    #   diagnostic information designed to help you understand how the document was
    #   processed. The document is not added to the index.
    # @param environment_id [String] The ID of the environment.
    # @param configuration [String] The configuration to use to process the document. If this part is provided, then
    #   the provided configuration is used to process the document. If the
    #   **configuration_id** is also provided (both are present at the same time), then
    #   request is rejected. The maximum supported configuration size is 1 MB.
    #   Configuration parts larger than 1 MB are rejected.
    #   See the `GET /configurations/{configuration_id}` operation for an example
    #   configuration.
    # @param step [String] Specify to only run the input document through the given step instead of running
    #   the input document through the entire ingestion workflow. Valid values are
    #   `convert`, `enrich`, and `normalize`.
    # @param configuration_id [String] The ID of the configuration to use to process the document. If the
    #   **configuration** form part is also provided (both are present at the same time),
    #   then the request will be rejected.
    # @param file [File] The content of the document to ingest. The maximum supported file size is 50
    #   megabytes. Files larger than 50 megabytes is rejected.
    # @param metadata [String] If you're using the Data Crawler to upload your documents, you can test a document
    #   against the type of metadata that the Data Crawler might send. The maximum
    #   supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
    #   rejected.
    #   Example:  ``` {
    #     \"Creator\": \"Johnny Appleseed\",
    #     \"Subject\": \"Apples\"
    #   } ```.
    # @param file_content_type [String] The content type of file.
    # @param filename [String] The filename for file.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def test_configuration_in_environment(environment_id:, configuration: nil, step: nil, configuration_id: nil, file: nil, metadata: nil, file_content_type: nil, filename: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "step" => step,
        "configuration_id" => configuration_id
      }
      unless file.nil?
        mime_type = file_content_type.nil? ? "application/octet-stream" : file_content_type
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        if filename
          file = file.instance_of?(StringIO) ? HTTP::FormData::File.new(file, content_type: mime_type, filename: filename) : HTTP::FormData::File.new(file.path, content_type: mime_type, filename: filename)
        else
          file = file.instance_of?(StringIO) ? HTTP::FormData::File.new(file, content_type: mime_type) : HTTP::FormData::File.new(file.path, content_type: mime_type)
        end
      end
      method_url = "/v1/environments/%s/preview" % [url_encode(environment_id)]
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: {
          configuration: configuration,
          file: file,
          metadata: metadata
        },
        accept_json: true
      )
      response
    end
    #########################
    # Collections
    #########################

    ##
    # @!method create_collection(environment_id:, name:, description: nil, configuration_id: nil, language: nil)
    # Create a collection.
    # @param environment_id [String] The ID of the environment.
    # @param name [String] The name of the collection to be created.
    # @param description [String] A description of the collection.
    # @param configuration_id [String] The ID of the configuration in which the collection is to be created.
    # @param language [String] The language of the documents stored in the collection, in the form of an ISO
    #   639-1 language code.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_collection(environment_id:, name:, description: nil, configuration_id: nil, language: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("name must be provided") if name.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "name" => name,
        "description" => description,
        "configuration_id" => configuration_id,
        "language" => language
      }
      method_url = "/v1/environments/%s/collections" % [url_encode(environment_id)]
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
    # @!method list_collections(environment_id:, name: nil)
    # List collections.
    # Lists existing collections for the service instance.
    # @param environment_id [String] The ID of the environment.
    # @param name [String] Find collections with the given name.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_collections(environment_id:, name: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "name" => name
      }
      method_url = "/v1/environments/%s/collections" % [url_encode(environment_id)]
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
    # @!method get_collection(environment_id:, collection_id:)
    # Get collection details.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_collection(environment_id:, collection_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method update_collection(environment_id:, collection_id:, name:, description: nil, configuration_id: nil)
    # Update a collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param name [String] The name of the collection.
    # @param description [String] A description of the collection.
    # @param configuration_id [String] The ID of the configuration in which the collection is to be updated.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def update_collection(environment_id:, collection_id:, name:, description: nil, configuration_id: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "name" => name,
        "description" => description,
        "configuration_id" => configuration_id
      }
      method_url = "/v1/environments/%s/collections/%s" % [url_encode(environment_id), url_encode(collection_id)]
      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_collection(environment_id:, collection_id:)
    # Delete a collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def delete_collection(environment_id:, collection_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s" % [url_encode(environment_id), url_encode(collection_id)]
      response = request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_collection_fields(environment_id:, collection_id:)
    # List collection fields.
    # Gets a list of the unique fields (and their types) stored in the index.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_collection_fields(environment_id:, collection_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/fields" % [url_encode(environment_id), url_encode(collection_id)]
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
    # Expansions
    #########################

    ##
    # @!method list_expansions(environment_id:, collection_id:)
    # Get the expansion list.
    # Returns the current expansion list for the specified collection. If an expansion
    #   list is not specified, an object with empty expansion arrays is returned.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_expansions(environment_id:, collection_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/expansions" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method create_expansions(environment_id:, collection_id:, expansions:)
    # Create or update expansion list.
    # Create or replace the Expansion list for this collection. The maximum number of
    #   expanded terms per collection is `500`.
    #   The current expansion list is replaced with the uploaded content.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param expansions [Array[Expansion]] An array of query expansion definitions.
    #
    #    Each object in the **expansions** array represents a term or set of terms that
    #   will be expanded into other terms. Each expansion object can be configured as
    #   bidirectional or unidirectional. Bidirectional means that all terms are expanded
    #   to all other terms in the object. Unidirectional means that a set list of terms
    #   can be expanded into a second list of terms.
    #
    #    To create a bi-directional expansion specify an **expanded_terms** array. When
    #   found in a query, all items in the **expanded_terms** array are then expanded to
    #   the other items in the same array.
    #
    #    To create a uni-directional expansion, specify both an array of **input_terms**
    #   and an array of **expanded_terms**. When items in the **input_terms** array are
    #   present in a query, they are expanded using the items listed in the
    #   **expanded_terms** array.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_expansions(environment_id:, collection_id:, expansions:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("expansions must be provided") if expansions.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "expansions" => expansions
      }
      method_url = "/v1/environments/%s/collections/%s/expansions" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method delete_expansions(environment_id:, collection_id:)
    # Delete the expansion list.
    # Remove the expansion information for this collection. The expansion list must be
    #   deleted to disable query expansion for a collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [nil]
    def delete_expansions(environment_id:, collection_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/expansions" % [url_encode(environment_id), url_encode(collection_id)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end
    #########################
    # Documents
    #########################

    ##
    # @!method add_document(environment_id:, collection_id:, file: nil, metadata: nil, file_content_type: nil, filename: nil)
    # Add a document.
    # Add a document to a collection with optional metadata.
    #
    #     * The **version** query parameter is still required.
    #
    #     * Returns immediately after the system has accepted the document for processing.
    #
    #     * The user must provide document content, metadata, or both. If the request is
    #   missing both document content and metadata, it is rejected.
    #
    #     * The user can set the **Content-Type** parameter on the **file** part to
    #   indicate the media type of the document. If the **Content-Type** parameter is
    #   missing or is one of the generic media types (for example,
    #   `application/octet-stream`), then the service attempts to automatically detect the
    #   document's media type.
    #
    #     * The following field names are reserved and will be filtered out if present
    #   after normalization: `id`, `score`, `highlight`, and any field with the prefix of:
    #   `_`, `+`, or `-`
    #
    #     * Fields with empty name values after normalization are filtered out before
    #   indexing.
    #
    #     * Fields containing the following characters after normalization are filtered
    #   out before indexing: `#` and `,`.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param file [File] The content of the document to ingest. The maximum supported file size is 50
    #   megabytes. Files larger than 50 megabytes is rejected.
    # @param metadata [String] If you're using the Data Crawler to upload your documents, you can test a document
    #   against the type of metadata that the Data Crawler might send. The maximum
    #   supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
    #   rejected.
    #   Example:  ``` {
    #     \"Creator\": \"Johnny Appleseed\",
    #     \"Subject\": \"Apples\"
    #   } ```.
    # @param file_content_type [String] The content type of file.
    # @param filename [String] The filename for file.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def add_document(environment_id:, collection_id:, file: nil, metadata: nil, file_content_type: nil, filename: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      unless file.nil?
        mime_type = file_content_type.nil? ? "application/octet-stream" : file_content_type
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        if filename
          file = file.instance_of?(StringIO) ? HTTP::FormData::File.new(file, content_type: mime_type, filename: filename) : HTTP::FormData::File.new(file.path, content_type: mime_type, filename: filename)
        else
          file = file.instance_of?(StringIO) ? HTTP::FormData::File.new(file, content_type: mime_type) : HTTP::FormData::File.new(file.path, content_type: mime_type)
        end
      end
      method_url = "/v1/environments/%s/collections/%s/documents" % [url_encode(environment_id), url_encode(collection_id)]
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: {
          file: file,
          metadata: metadata
        },
        accept_json: true
      )
      response
    end

    ##
    # @!method get_document_status(environment_id:, collection_id:, document_id:)
    # Get document details.
    # Fetch status details about a submitted document. **Note:** this operation does not
    #   return the document itself. Instead, it returns only the document's processing
    #   status and any notices (warnings or errors) that were generated when the document
    #   was ingested. Use the query API to retrieve the actual document content.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_document_status(environment_id:, collection_id:, document_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("document_id must be provided") if document_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/documents/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(document_id)]
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
    # @!method update_document(environment_id:, collection_id:, document_id:, file: nil, metadata: nil, file_content_type: nil, filename: nil)
    # Update a document.
    # Replace an existing document. Starts ingesting a document with optional metadata.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @param file [File] The content of the document to ingest. The maximum supported file size is 50
    #   megabytes. Files larger than 50 megabytes is rejected.
    # @param metadata [String] If you're using the Data Crawler to upload your documents, you can test a document
    #   against the type of metadata that the Data Crawler might send. The maximum
    #   supported metadata file size is 1 MB. Metadata parts larger than 1 MB are
    #   rejected.
    #   Example:  ``` {
    #     \"Creator\": \"Johnny Appleseed\",
    #     \"Subject\": \"Apples\"
    #   } ```.
    # @param file_content_type [String] The content type of file.
    # @param filename [String] The filename for file.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def update_document(environment_id:, collection_id:, document_id:, file: nil, metadata: nil, file_content_type: nil, filename: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("document_id must be provided") if document_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      unless file.nil?
        mime_type = file_content_type.nil? ? "application/octet-stream" : file_content_type
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        if filename
          file = file.instance_of?(StringIO) ? HTTP::FormData::File.new(file, content_type: mime_type, filename: filename) : HTTP::FormData::File.new(file.path, content_type: mime_type, filename: filename)
        else
          file = file.instance_of?(StringIO) ? HTTP::FormData::File.new(file, content_type: mime_type) : HTTP::FormData::File.new(file.path, content_type: mime_type)
        end
      end
      method_url = "/v1/environments/%s/collections/%s/documents/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(document_id)]
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: {
          file: file,
          metadata: metadata
        },
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_document(environment_id:, collection_id:, document_id:)
    # Delete a document.
    # If the given document ID is invalid, or if the document is not found, then the a
    #   success response is returned (HTTP status code `200`) with the status set to
    #   'deleted'.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def delete_document(environment_id:, collection_id:, document_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("document_id must be provided") if document_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/documents/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(document_id)]
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
    # Queries
    #########################

    ##
    # @!method query(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
    # Query your collection.
    # After your content is uploaded and enriched by the Discovery service, you can
    #   build queries to search your content. For details, see the [Discovery service
    #   documentation](https://console.bluemix.net/docs/services/discovery/using.html).
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param filter [String] A cacheable query that limits the documents returned to exclude any documents that
    #   don't mention the query content. Filter searches are better for metadata type
    #   searches and when you are trying to get a sense of concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results. You cannot use
    #   **natural_language_query** and **query** at the same time.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding. You cannot use **natural_language_query**
    #   and **query** at the same time.
    # @param passages [Boolean] A passages query that returns the most relevant passages from the results.
    # @param aggregation [String] An aggregation search uses combinations of filters and query search to return an
    #   exact answer. Aggregations are useful for building applications, because you can
    #   use them to build lists, tables, and time series. For a full list of possible
    #   aggregrations, see the Query reference.
    # @param count [Fixnum] Number of documents to return.
    # @param return_fields [Array[String]] A comma separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10, and the offset is 8, it returns the
    #   last two results.
    # @param sort [Array[String]] A comma separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @param highlight [Boolean] When true a highlight field is returned for each result which contains the fields
    #   that match the query with `<em></em>` tags around the matching query terms.
    #   Defaults to false.
    # @param passages_fields [Array[String]] A comma-separated list of fields that passages are drawn from. If this parameter
    #   not specified, then all top-level fields are included.
    # @param passages_count [Fixnum] The maximum number of passages to return. The search returns fewer passages if the
    #   requested total is not found. The default is `10`. The maximum is `100`.
    # @param passages_characters [Fixnum] The approximate number of characters that any one passage will have. The default
    #   is `400`. The minimum is `50`. The maximum is `2000`.
    # @param deduplicate [Boolean] When `true` and used with a Watson Discovery News collection, duplicate results
    #   (based on the contents of the **title** field) are removed. Duplicate comparison
    #   is limited to the current query only; **offset** is not considered. This parameter
    #   is currently Beta functionality.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [Array[String]] A comma-separated list of document IDs that will be used to find similar
    #   documents.
    #
    #   **Note:** If the **natural_language_query** parameter is also specified, it will
    #   be used to expand the scope of the document similarity search to include the
    #   natural language query. Other query parameters, such as **filter** and **query**
    #   are subsequently applied and reduce the query scope.
    # @param similar_fields [Array[String]] A comma-separated list of field names that will be used as a basis for comparison
    #   to identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def query(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "passages" => passages,
        "aggregation" => aggregation,
        "count" => count,
        "return" => return_fields.to_a,
        "offset" => offset,
        "sort" => sort.to_a,
        "highlight" => highlight,
        "passages.fields" => passages_fields.to_a,
        "passages.count" => passages_count,
        "passages.characters" => passages_characters,
        "deduplicate" => deduplicate,
        "deduplicate.field" => deduplicate_field,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids.to_a,
        "similar.fields" => similar_fields.to_a
      }
      method_url = "/v1/environments/%s/collections/%s/query" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method query_notices(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
    # Query system notices.
    # Queries for notices (errors or warnings) that might have been generated by the
    #   system. Notices are generated when ingesting documents and performing relevance
    #   training. See the [Discovery service
    #   documentation](https://console.bluemix.net/docs/services/discovery/using.html) for
    #   more details on the query language.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param filter [String] A cacheable query that limits the documents returned to exclude any documents that
    #   don't mention the query content. Filter searches are better for metadata type
    #   searches and when you are trying to get a sense of concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results. You cannot use
    #   **natural_language_query** and **query** at the same time.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding. You cannot use **natural_language_query**
    #   and **query** at the same time.
    # @param passages [Boolean] A passages query that returns the most relevant passages from the results.
    # @param aggregation [String] An aggregation search uses combinations of filters and query search to return an
    #   exact answer. Aggregations are useful for building applications, because you can
    #   use them to build lists, tables, and time series. For a full list of possible
    #   aggregrations, see the Query reference.
    # @param count [Fixnum] Number of documents to return.
    # @param return_fields [Array[String]] A comma separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10, and the offset is 8, it returns the
    #   last two results.
    # @param sort [Array[String]] A comma separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @param highlight [Boolean] When true a highlight field is returned for each result which contains the fields
    #   that match the query with `<em></em>` tags around the matching query terms.
    #   Defaults to false.
    # @param passages_fields [Array[String]] A comma-separated list of fields that passages are drawn from. If this parameter
    #   not specified, then all top-level fields are included.
    # @param passages_count [Fixnum] The maximum number of passages to return. The search returns fewer passages if the
    #   requested total is not found. The default is `10`. The maximum is `100`.
    # @param passages_characters [Fixnum] The approximate number of characters that any one passage will have. The default
    #   is `400`. The minimum is `50`. The maximum is `2000`.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [Array[String]] A comma-separated list of document IDs that will be used to find similar
    #   documents.
    #
    #   **Note:** If the **natural_language_query** parameter is also specified, it will
    #   be used to expand the scope of the document similarity search to include the
    #   natural language query. Other query parameters, such as **filter** and **query**
    #   are subsequently applied and reduce the query scope.
    # @param similar_fields [Array[String]] A comma-separated list of field names that will be used as a basis for comparison
    #   to identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def query_notices(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "passages" => passages,
        "aggregation" => aggregation,
        "count" => count,
        "return_fields" => return_fields.to_a,
        "offset" => offset,
        "sort" => sort.to_a,
        "highlight" => highlight,
        "passages.fields" => passages_fields.to_a,
        "passages.count" => passages_count,
        "passages.characters" => passages_characters,
        "deduplicate.field" => deduplicate_field,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids.to_a,
        "similar.fields" => similar_fields.to_a
      }
      method_url = "/v1/environments/%s/collections/%s/notices" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method federated_query(environment_id:, collection_ids:, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, deduplicate: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil, passages: nil, passages_fields: nil, passages_count: nil, passages_characters: nil)
    # Query documents in multiple collections.
    # See the [Discovery service
    #   documentation](https://console.bluemix.net/docs/services/discovery/using.html) for
    #   more details.
    # @param environment_id [String] The ID of the environment.
    # @param collection_ids [Array[String]] A comma-separated list of collection IDs to be queried against.
    # @param filter [String] A cacheable query that limits the documents returned to exclude any documents that
    #   don't mention the query content. Filter searches are better for metadata type
    #   searches and when you are trying to get a sense of concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results. You cannot use
    #   **natural_language_query** and **query** at the same time.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding. You cannot use **natural_language_query**
    #   and **query** at the same time.
    # @param aggregation [String] An aggregation search uses combinations of filters and query search to return an
    #   exact answer. Aggregations are useful for building applications, because you can
    #   use them to build lists, tables, and time series. For a full list of possible
    #   aggregrations, see the Query reference.
    # @param count [Fixnum] Number of documents to return.
    # @param return_fields [Array[String]] A comma separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10, and the offset is 8, it returns the
    #   last two results.
    # @param sort [Array[String]] A comma separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @param highlight [Boolean] When true a highlight field is returned for each result which contains the fields
    #   that match the query with `<em></em>` tags around the matching query terms.
    #   Defaults to false.
    # @param deduplicate [Boolean] When `true` and used with a Watson Discovery News collection, duplicate results
    #   (based on the contents of the **title** field) are removed. Duplicate comparison
    #   is limited to the current query only; **offset** is not considered. This parameter
    #   is currently Beta functionality.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [Array[String]] A comma-separated list of document IDs that will be used to find similar
    #   documents.
    #
    #   **Note:** If the **natural_language_query** parameter is also specified, it will
    #   be used to expand the scope of the document similarity search to include the
    #   natural language query. Other query parameters, such as **filter** and **query**
    #   are subsequently applied and reduce the query scope.
    # @param similar_fields [Array[String]] A comma-separated list of field names that will be used as a basis for comparison
    #   to identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @param passages [Boolean] A passages query that returns the most relevant passages from the results.
    # @param passages_fields [Array[String]] A comma-separated list of fields that passages are drawn from. If this parameter
    #   not specified, then all top-level fields are included.
    # @param passages_count [Fixnum] The maximum number of passages to return. The search returns fewer passages if the
    #   requested total is not found. The default is `10`. The maximum is `100`.
    # @param passages_characters [Fixnum] The approximate number of characters that any one passage will have. The default
    #   is `400`. The minimum is `50`. The maximum is `2000`.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def federated_query(environment_id:, collection_ids:, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, deduplicate: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil, passages: nil, passages_fields: nil, passages_count: nil, passages_characters: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_ids must be provided") if collection_ids.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "collection_ids" => collection_ids.to_a,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "aggregation" => aggregation,
        "count" => count,
        "return_fields" => return_fields.to_a,
        "offset" => offset,
        "sort" => sort.to_a,
        "highlight" => highlight,
        "deduplicate" => deduplicate,
        "deduplicate.field" => deduplicate_field,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids.to_a,
        "similar.fields" => similar_fields.to_a,
        "passages" => passages,
        "passages.fields" => passages_fields.to_a,
        "passages.count" => passages_count,
        "passages.characters" => passages_characters
      }
      method_url = "/v1/environments/%s/query" % [url_encode(environment_id)]
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
    # @!method federated_query_notices(environment_id:, collection_ids:, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
    # Query multiple collection system notices.
    # Queries for notices (errors or warnings) that might have been generated by the
    #   system. Notices are generated when ingesting documents and performing relevance
    #   training. See the [Discovery service
    #   documentation](https://console.bluemix.net/docs/services/discovery/using.html) for
    #   more details on the query language.
    # @param environment_id [String] The ID of the environment.
    # @param collection_ids [Array[String]] A comma-separated list of collection IDs to be queried against.
    # @param filter [String] A cacheable query that limits the documents returned to exclude any documents that
    #   don't mention the query content. Filter searches are better for metadata type
    #   searches and when you are trying to get a sense of concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results. You cannot use
    #   **natural_language_query** and **query** at the same time.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding. You cannot use **natural_language_query**
    #   and **query** at the same time.
    # @param aggregation [String] An aggregation search uses combinations of filters and query search to return an
    #   exact answer. Aggregations are useful for building applications, because you can
    #   use them to build lists, tables, and time series. For a full list of possible
    #   aggregrations, see the Query reference.
    # @param count [Fixnum] Number of documents to return.
    # @param return_fields [Array[String]] A comma separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10, and the offset is 8, it returns the
    #   last two results.
    # @param sort [Array[String]] A comma separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @param highlight [Boolean] When true a highlight field is returned for each result which contains the fields
    #   that match the query with `<em></em>` tags around the matching query terms.
    #   Defaults to false.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [Array[String]] A comma-separated list of document IDs that will be used to find similar
    #   documents.
    #
    #   **Note:** If the **natural_language_query** parameter is also specified, it will
    #   be used to expand the scope of the document similarity search to include the
    #   natural language query. Other query parameters, such as **filter** and **query**
    #   are subsequently applied and reduce the query scope.
    # @param similar_fields [Array[String]] A comma-separated list of field names that will be used as a basis for comparison
    #   to identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def federated_query_notices(environment_id:, collection_ids:, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_ids must be provided") if collection_ids.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "collection_ids" => collection_ids.to_a,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "aggregation" => aggregation,
        "count" => count,
        "return_fields" => return_fields.to_a,
        "offset" => offset,
        "sort" => sort.to_a,
        "highlight" => highlight,
        "deduplicate.field" => deduplicate_field,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids.to_a,
        "similar.fields" => similar_fields.to_a
      }
      method_url = "/v1/environments/%s/notices" % [url_encode(environment_id)]
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
    # @!method query_entities(environment_id:, collection_id:, feature: nil, entity: nil, context: nil, count: nil, evidence_count: nil)
    # Knowledge Graph entity query.
    # See the [Knowledge Graph
    #   documentation](https://console.bluemix.net/docs/services/discovery/building-kg.html)
    #   for more details.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param feature [String] The entity query feature to perform. Supported features are `disambiguate` and
    #   `similar_entities`.
    # @param entity [QueryEntitiesEntity] A text string that appears within the entity text field.
    # @param context [QueryEntitiesContext] Entity text to provide context for the queried entity and rank based on that
    #   association. For example, if you wanted to query the city of London in England
    #   your query would look for `London` with the context of `England`.
    # @param count [Fixnum] The number of results to return. The default is `10`. The maximum is `1000`.
    # @param evidence_count [Fixnum] The number of evidence items to return for each result. The default is `0`. The
    #   maximum number of evidence items per query is 10,000.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def query_entities(environment_id:, collection_id:, feature: nil, entity: nil, context: nil, count: nil, evidence_count: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "feature" => feature,
        "entity" => entity,
        "context" => context,
        "count" => count,
        "evidence_count" => evidence_count
      }
      method_url = "/v1/environments/%s/collections/%s/query_entities" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method query_relations(environment_id:, collection_id:, entities: nil, context: nil, sort: nil, filter: nil, count: nil, evidence_count: nil)
    # Knowledge Graph relationship query.
    # See the [Knowledge Graph
    #   documentation](https://console.bluemix.net/docs/services/discovery/building-kg.html)
    #   for more details.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param entities [Array[QueryRelationsEntity]] An array of entities to find relationships for.
    # @param context [QueryEntitiesContext] Entity text to provide context for the queried entity and rank based on that
    #   association. For example, if you wanted to query the city of London in England
    #   your query would look for `London` with the context of `England`.
    # @param sort [String] The sorting method for the relationships, can be `score` or `frequency`.
    #   `frequency` is the number of unique times each entity is identified. The default
    #   is `score`.
    # @param filter [QueryRelationsFilter] Filters to apply to the relationship query.
    # @param count [Fixnum] The number of results to return. The default is `10`. The maximum is `1000`.
    # @param evidence_count [Fixnum] The number of evidence items to return for each result. The default is `0`. The
    #   maximum number of evidence items per query is 10,000.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def query_relations(environment_id:, collection_id:, entities: nil, context: nil, sort: nil, filter: nil, count: nil, evidence_count: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "entities" => entities,
        "context" => context,
        "sort" => sort,
        "filter" => filter,
        "count" => count,
        "evidence_count" => evidence_count
      }
      method_url = "/v1/environments/%s/collections/%s/query_relations" % [url_encode(environment_id), url_encode(collection_id)]
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
    #########################
    # Training data
    #########################

    ##
    # @!method list_training_data(environment_id:, collection_id:)
    # List training data.
    # Lists the training data for the specified collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_training_data(environment_id:, collection_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/training_data" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method add_training_data(environment_id:, collection_id:, natural_language_query: nil, filter: nil, examples: nil)
    # Add query to training data.
    # Adds a query to the training data for this collection. The query can contain a
    #   filter and natural language query.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param natural_language_query [String]
    # @param filter [String]
    # @param examples [Array[TrainingExample]]
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def add_training_data(environment_id:, collection_id:, natural_language_query: nil, filter: nil, examples: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "natural_language_query" => natural_language_query,
        "filter" => filter,
        "examples" => examples
      }
      method_url = "/v1/environments/%s/collections/%s/training_data" % [url_encode(environment_id), url_encode(collection_id)]
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
    # @!method delete_all_training_data(environment_id:, collection_id:)
    # Delete all training data.
    # Deletes all training data from a collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [nil]
    def delete_all_training_data(environment_id:, collection_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/training_data" % [url_encode(environment_id), url_encode(collection_id)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end

    ##
    # @!method get_training_data(environment_id:, collection_id:, query_id:)
    # Get details about a query.
    # Gets details for a specific training data query, including the query string and
    #   all examples.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_training_data(environment_id:, collection_id:, query_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("query_id must be provided") if query_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/training_data/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(query_id)]
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
    # @!method delete_training_data(environment_id:, collection_id:, query_id:)
    # Delete a training data query.
    # Removes the training data query and all associated examples from the training data
    #   set.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @return [nil]
    def delete_training_data(environment_id:, collection_id:, query_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("query_id must be provided") if query_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/training_data/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(query_id)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end

    ##
    # @!method list_training_examples(environment_id:, collection_id:, query_id:)
    # List examples for a training data query.
    # List all examples for this training data query.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_training_examples(environment_id:, collection_id:, query_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("query_id must be provided") if query_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples" % [url_encode(environment_id), url_encode(collection_id), url_encode(query_id)]
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
    # @!method create_training_example(environment_id:, collection_id:, query_id:, document_id: nil, cross_reference: nil, relevance: nil)
    # Add example to training data query.
    # Adds a example to this training data query.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @param document_id [String]
    # @param cross_reference [String]
    # @param relevance [Fixnum]
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_training_example(environment_id:, collection_id:, query_id:, document_id: nil, cross_reference: nil, relevance: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("query_id must be provided") if query_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "document_id" => document_id,
        "cross_reference" => cross_reference,
        "relevance" => relevance
      }
      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples" % [url_encode(environment_id), url_encode(collection_id), url_encode(query_id)]
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
    # @!method delete_training_example(environment_id:, collection_id:, query_id:, example_id:)
    # Delete example for training data query.
    # Deletes the example document with the given ID from the training data query.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @param example_id [String] The ID of the document as it is indexed.
    # @return [nil]
    def delete_training_example(environment_id:, collection_id:, query_id:, example_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("query_id must be provided") if query_id.nil?
      raise ArgumentError("example_id must be provided") if example_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(query_id), url_encode(example_id)]
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end

    ##
    # @!method update_training_example(environment_id:, collection_id:, query_id:, example_id:, cross_reference: nil, relevance: nil)
    # Change label or cross reference for example.
    # Changes the label or cross reference query for this training data example.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @param example_id [String] The ID of the document as it is indexed.
    # @param cross_reference [String]
    # @param relevance [Fixnum]
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def update_training_example(environment_id:, collection_id:, query_id:, example_id:, cross_reference: nil, relevance: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("query_id must be provided") if query_id.nil?
      raise ArgumentError("example_id must be provided") if example_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "cross_reference" => cross_reference,
        "relevance" => relevance
      }
      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(query_id), url_encode(example_id)]
      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_training_example(environment_id:, collection_id:, query_id:, example_id:)
    # Get details for training data example.
    # Gets the details for this training example.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @param example_id [String] The ID of the document as it is indexed.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_training_example(environment_id:, collection_id:, query_id:, example_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("collection_id must be provided") if collection_id.nil?
      raise ArgumentError("query_id must be provided") if query_id.nil?
      raise ArgumentError("example_id must be provided") if example_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples/%s" % [url_encode(environment_id), url_encode(collection_id), url_encode(query_id), url_encode(example_id)]
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
    # User data
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
    #   security](https://console.bluemix.net/docs/services/discovery/information-security.html).
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError("customer_id must be provided") if customer_id.nil?
      headers = {
      }
      params = {
        "version" => @version,
        "customer_id" => customer_id
      }
      method_url = "/v1/user_data"
      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end
    #########################
    # Credentials
    #########################

    ##
    # @!method list_credentials(environment_id:)
    # List credentials.
    # List all the source credentials that have been created for this service instance.
    #
    #    **Note:**  All credentials are sent over an encrypted connection and encrypted at
    #   rest.
    # @param environment_id [String] The ID of the environment.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_credentials(environment_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/credentials" % [url_encode(environment_id)]
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
    # @!method create_credentials(environment_id:, source_type: nil, credential_details: nil)
    # Create credentials.
    # Creates a set of credentials to connect to a remote source. Created credentials
    #   are used in a configuration to associate a collection with the remote source.
    #
    #   **Note:** All credentials are sent over an encrypted connection and encrypted at
    #   rest.
    # @param environment_id [String] The ID of the environment.
    # @param source_type [String] The source that this credentials object connects to.
    #   -  `box` indicates the credentials are used to connect an instance of Enterprise
    #   Box.
    #   -  `salesforce` indicates the credentials are used to connect to Salesforce.
    #   -  `sharepoint` indicates the credentials are used to connect to Microsoft
    #   SharePoint Online.
    # @param credential_details [CredentialDetails] Object containing details of the stored credentials.
    #
    #   Obtain credentials for your source from the administrator of the source.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_credentials(environment_id:, source_type: nil, credential_details: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "source_type" => source_type,
        "credential_details" => credential_details
      }
      method_url = "/v1/environments/%s/credentials" % [url_encode(environment_id)]
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
    # @!method get_credentials(environment_id:, credential_id:)
    # View Credentials.
    # Returns details about the specified credentials.
    #
    #    **Note:** Secure credential information such as a password or SSH key is never
    #   returned and must be obtained from the source system.
    # @param environment_id [String] The ID of the environment.
    # @param credential_id [String] The unique identifier for a set of source credentials.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_credentials(environment_id:, credential_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("credential_id must be provided") if credential_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/credentials/%s" % [url_encode(environment_id), url_encode(credential_id)]
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
    # @!method update_credentials(environment_id:, credential_id:, source_type: nil, credential_details: nil)
    # Update credentials.
    # Updates an existing set of source credentials.
    #
    #   **Note:** All credentials are sent over an encrypted connection and encrypted at
    #   rest.
    # @param environment_id [String] The ID of the environment.
    # @param credential_id [String] The unique identifier for a set of source credentials.
    # @param source_type [String] The source that this credentials object connects to.
    #   -  `box` indicates the credentials are used to connect an instance of Enterprise
    #   Box.
    #   -  `salesforce` indicates the credentials are used to connect to Salesforce.
    #   -  `sharepoint` indicates the credentials are used to connect to Microsoft
    #   SharePoint Online.
    # @param credential_details [CredentialDetails] Object containing details of the stored credentials.
    #
    #   Obtain credentials for your source from the administrator of the source.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def update_credentials(environment_id:, credential_id:, source_type: nil, credential_details: nil)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("credential_id must be provided") if credential_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      data = {
        "source_type" => source_type,
        "credential_details" => credential_details
      }
      method_url = "/v1/environments/%s/credentials/%s" % [url_encode(environment_id), url_encode(credential_id)]
      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_credentials(environment_id:, credential_id:)
    # Delete credentials.
    # Deletes a set of stored credentials from your Discovery instance.
    # @param environment_id [String] The ID of the environment.
    # @param credential_id [String] The unique identifier for a set of source credentials.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def delete_credentials(environment_id:, credential_id:)
      raise ArgumentError("environment_id must be provided") if environment_id.nil?
      raise ArgumentError("credential_id must be provided") if credential_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      method_url = "/v1/environments/%s/credentials/%s" % [url_encode(environment_id), url_encode(credential_id)]
      response = request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
  end
end
