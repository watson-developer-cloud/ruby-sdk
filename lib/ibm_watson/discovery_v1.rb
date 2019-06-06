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

# Module for the Watson APIs
module IBMWatson
  ##
  # The Discovery V1 service.
  class DiscoveryV1 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
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
    #   The base url may differ between IBM Cloud regions.
    # @option args username [String] The username used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of IBM Cloud. When running on
    #   IBM Cloud, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args password [String] The password used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of IBM Cloud. When running on
    #   IBM Cloud, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args iam_apikey [String] An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # @option args iam_access_token [String] An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # @option args iam_url [String] An optional URL for the IAM service API. Defaults to
    #   'https://iam.cloud.ibm.com/identity/token'.
    # @option args iam_client_id [String] An optional client id for the IAM service API.
    # @option args iam_client_secret [String] An optional client secret for the IAM service API.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/discovery/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      defaults[:iam_client_id] = nil
      defaults[:iam_client_secret] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "discovery"
      super
      @version = args[:version]
      args[:display_name] = "Discovery"
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
    # @param size [String] Size of the environment. In the Lite plan the default and only accepted value is
    #   `LT`, in all other plans the default is `S`.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_environment(name:, description: nil, size: nil)
      raise ArgumentError.new("name must be provided") if name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_environment")
      headers.merge!(sdk_headers)

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_environments(name: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_environments")
      headers.merge!(sdk_headers)

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_environment(environment_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_environment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s" % [ERB::Util.url_encode(environment_id)]

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
    # @!method update_environment(environment_id:, name: nil, description: nil, size: nil)
    # Update an environment.
    # Updates an environment. The environment's **name** and  **description** parameters
    #   can be changed. You must specify a **name** for the environment.
    # @param environment_id [String] The ID of the environment.
    # @param name [String] Name that identifies the environment.
    # @param description [String] Description of the environment.
    # @param size [String] Size that the environment should be increased to. Environment size cannot be
    #   modified when using a Lite plan. Environment size can only increased and not
    #   decreased.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_environment(environment_id:, name: nil, description: nil, size: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "update_environment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description,
        "size" => size
      }

      method_url = "/v1/environments/%s" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_environment(environment_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_environment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_fields(environment_id:, collection_ids:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_ids must be provided") if collection_ids.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_fields")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "collection_ids" => collection_ids.to_a
      }

      method_url = "/v1/environments/%s/fields" % [ERB::Util.url_encode(environment_id)]

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
    # @param conversions [Conversions] Document conversion settings.
    # @param enrichments [Array[Enrichment]] An array of document enrichment settings for the configuration.
    # @param normalizations [Array[NormalizationOperation]] Defines operations that can be used to transform the final output JSON into a
    #   normalized form. Operations are executed in the order that they appear in the
    #   array.
    # @param source [Source] Object containing source parameters for the configuration.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_configuration(environment_id:, name:, description: nil, conversions: nil, enrichments: nil, normalizations: nil, source: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("name must be provided") if name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_configuration")
      headers.merge!(sdk_headers)

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

      method_url = "/v1/environments/%s/configurations" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_configurations(environment_id:, name: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_configurations")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "name" => name
      }

      method_url = "/v1/environments/%s/configurations" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_configuration(environment_id:, configuration_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("configuration_id must be provided") if configuration_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_configuration")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/configurations/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(configuration_id)]

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
    # @param conversions [Conversions] Document conversion settings.
    # @param enrichments [Array[Enrichment]] An array of document enrichment settings for the configuration.
    # @param normalizations [Array[NormalizationOperation]] Defines operations that can be used to transform the final output JSON into a
    #   normalized form. Operations are executed in the order that they appear in the
    #   array.
    # @param source [Source] Object containing source parameters for the configuration.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_configuration(environment_id:, configuration_id:, name:, description: nil, conversions: nil, enrichments: nil, normalizations: nil, source: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("configuration_id must be provided") if configuration_id.nil?

      raise ArgumentError.new("name must be provided") if name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "update_configuration")
      headers.merge!(sdk_headers)

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

      method_url = "/v1/environments/%s/configurations/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(configuration_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_configuration(environment_id:, configuration_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("configuration_id must be provided") if configuration_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_configuration")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/configurations/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(configuration_id)]

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
    # @!method test_configuration_in_environment(environment_id:, configuration: nil, file: nil, filename: nil, file_content_type: nil, metadata: nil, step: nil, configuration_id: nil)
    # Test configuration.
    # **Deprecated** This method is no longer supported and is scheduled to be removed
    #   from service on July 31st 2019.
    #
    #    Runs a sample document through the default or your configuration and returns
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
    # @param file [File] The content of the document to ingest. The maximum supported file size when adding
    #   a file to a collection is 50 megabytes, the maximum supported file size when
    #   testing a confiruration is 1 megabyte. Files larger than the supported size are
    #   rejected.
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected.
    #   Example:  ``` {
    #     \"Creator\": \"Johnny Appleseed\",
    #     \"Subject\": \"Apples\"
    #   } ```.
    # @param step [String] Specify to only run the input document through the given step instead of running
    #   the input document through the entire ingestion workflow. Valid values are
    #   `convert`, `enrich`, and `normalize`.
    # @param configuration_id [String] The ID of the configuration to use to process the document. If the
    #   **configuration** form part is also provided (both are present at the same time),
    #   then the request will be rejected.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def test_configuration_in_environment(environment_id:, configuration: nil, file: nil, filename: nil, file_content_type: nil, metadata: nil, step: nil, configuration_id: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "test_configuration_in_environment")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "step" => step,
        "configuration_id" => configuration_id
      }

      form_data = {}

      form_data[:configuration] = HTTP::FormData::Part.new(configuration.to_s, content_type: "text/plain") unless configuration.nil?

      unless file.nil?
        unless file.instance_of?(StringIO) || file.instance_of?(File)
          file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
        end
        filename = file.path if filename.nil? && file.respond_to?(:path)
        form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: filename)
      end

      form_data[:metadata] = HTTP::FormData::Part.new(metadata.to_s, content_type: "text/plain") unless metadata.nil?

      method_url = "/v1/environments/%s/preview" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_collection(environment_id:, name:, description: nil, configuration_id: nil, language: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("name must be provided") if name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description,
        "configuration_id" => configuration_id,
        "language" => language
      }

      method_url = "/v1/environments/%s/collections" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_collections(environment_id:, name: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_collections")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "name" => name
      }

      method_url = "/v1/environments/%s/collections" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_collection(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_collection(environment_id:, collection_id:, name:, description: nil, configuration_id: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "update_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description,
        "configuration_id" => configuration_id
      }

      method_url = "/v1/environments/%s/collections/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_collection(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_collection_fields(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_collection_fields")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/fields" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # Query modifications
    #########################

    ##
    # @!method list_expansions(environment_id:, collection_id:)
    # Get the expansion list.
    # Returns the current expansion list for the specified collection. If an expansion
    #   list is not specified, an object with empty expansion arrays is returned.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_expansions(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_expansions")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/expansions" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_expansions(environment_id:, collection_id:, expansions:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("expansions must be provided") if expansions.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_expansions")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "expansions" => expansions
      }

      method_url = "/v1/environments/%s/collections/%s/expansions" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_expansions")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/expansions" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method get_tokenization_dictionary_status(environment_id:, collection_id:)
    # Get tokenization dictionary status.
    # Returns the current status of the tokenization dictionary for the specified
    #   collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_tokenization_dictionary_status(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_tokenization_dictionary_status")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/word_lists/tokenization_dictionary" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method create_tokenization_dictionary(environment_id:, collection_id:, tokenization_rules: nil)
    # Create tokenization dictionary.
    # Upload a custom tokenization dictionary to use with the specified collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param tokenization_rules [Array[TokenDictRule]] An array of tokenization rules. Each rule contains, the original `text` string,
    #   component `tokens`, any alternate character set `readings`, and which
    #   `part_of_speech` the text is from.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_tokenization_dictionary(environment_id:, collection_id:, tokenization_rules: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_tokenization_dictionary")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "tokenization_rules" => tokenization_rules
      }

      method_url = "/v1/environments/%s/collections/%s/word_lists/tokenization_dictionary" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method delete_tokenization_dictionary(environment_id:, collection_id:)
    # Delete tokenization dictionary.
    # Delete the tokenization dictionary from the collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [nil]
    def delete_tokenization_dictionary(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_tokenization_dictionary")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/word_lists/tokenization_dictionary" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method get_stopword_list_status(environment_id:, collection_id:)
    # Get stopword list status.
    # Returns the current status of the stopword list for the specified collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_stopword_list_status(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_stopword_list_status")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/word_lists/stopwords" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method create_stopword_list(environment_id:, collection_id:, stopword_file:, stopword_filename: nil)
    # Create stopword list.
    # Upload a custom stopword list to use with the specified collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param stopword_file [File] The content of the stopword list to ingest.
    # @param stopword_filename [String] The filename for stopword_file.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_stopword_list(environment_id:, collection_id:, stopword_file:, stopword_filename: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("stopword_file must be provided") if stopword_file.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_stopword_list")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless stopword_file.instance_of?(StringIO) || stopword_file.instance_of?(File)
        stopword_file = stopword_file.respond_to?(:to_json) ? StringIO.new(stopword_file.to_json) : StringIO.new(stopword_file)
      end
      stopword_filename = stopword_file.path if stopword_filename.nil? && stopword_file.respond_to?(:path)
      form_data[:stopword_file] = HTTP::FormData::File.new(stopword_file, content_type: "application/octet-stream", filename: stopword_filename)

      method_url = "/v1/environments/%s/collections/%s/word_lists/stopwords" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method delete_stopword_list(environment_id:, collection_id:)
    # Delete a custom stopword list.
    # Delete a custom stopword list from the collection. After a custom stopword list is
    #   deleted, the default list is used for the collection.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @return [nil]
    def delete_stopword_list(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_stopword_list")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/word_lists/stopwords" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # Documents
    #########################

    ##
    # @!method add_document(environment_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil)
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
    #   out before indexing: `#` and `,`
    #
    #    **Note:** Documents can be added with a specific **document_id** by using the
    #   **_/v1/environments/{environment_id}/collections/{collection_id}/documents**
    #   method.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param file [File] The content of the document to ingest. The maximum supported file size when adding
    #   a file to a collection is 50 megabytes, the maximum supported file size when
    #   testing a confiruration is 1 megabyte. Files larger than the supported size are
    #   rejected.
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected.
    #   Example:  ``` {
    #     \"Creator\": \"Johnny Appleseed\",
    #     \"Subject\": \"Apples\"
    #   } ```.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def add_document(environment_id:, collection_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "add_document")
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

      method_url = "/v1/environments/%s/collections/%s/documents" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method get_document_status(environment_id:, collection_id:, document_id:)
    # Get document details.
    # Fetch status details about a submitted document. **Note:** this operation does not
    #   return the document itself. Instead, it returns only the document's processing
    #   status and any notices (warnings or errors) that were generated when the document
    #   was ingested. Use the query API to retrieve the actual document content.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_document_status(environment_id:, collection_id:, document_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_document_status")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/documents/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(document_id)]

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
    # @!method update_document(environment_id:, collection_id:, document_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil)
    # Update a document.
    # Replace an existing document or add a document with a specified **document_id**.
    #   Starts ingesting a document with optional metadata.
    #
    #   **Note:** When uploading a new document with this method it automatically replaces
    #   any document stored with the same **document_id** if it exists.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @param file [File] The content of the document to ingest. The maximum supported file size when adding
    #   a file to a collection is 50 megabytes, the maximum supported file size when
    #   testing a confiruration is 1 megabyte. Files larger than the supported size are
    #   rejected.
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param metadata [String] The maximum supported metadata file size is 1 MB. Metadata parts larger than 1 MB
    #   are rejected.
    #   Example:  ``` {
    #     \"Creator\": \"Johnny Appleseed\",
    #     \"Subject\": \"Apples\"
    #   } ```.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_document(environment_id:, collection_id:, document_id:, file: nil, filename: nil, file_content_type: nil, metadata: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "update_document")
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

      method_url = "/v1/environments/%s/collections/%s/documents/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(document_id)]

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
    # @!method delete_document(environment_id:, collection_id:, document_id:)
    # Delete a document.
    # If the given document ID is invalid, or if the document is not found, then the a
    #   success response is returned (HTTP status code `200`) with the status set to
    #   'deleted'.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param document_id [String] The ID of the document.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_document(environment_id:, collection_id:, document_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/documents/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(document_id)]

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
    # @!method query(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate: nil, deduplicate_field: nil, collection_ids: nil, similar: nil, similar_document_ids: nil, similar_fields: nil, bias: nil, logging_opt_out: nil)
    # Query a collection.
    # By using this method, you can construct long queries. For details, see the
    #   [Discovery
    #   documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts).
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param passages [Boolean] A passages query that returns the most relevant passages from the results.
    # @param aggregation [String] An aggregation search that returns an exact answer by combining query search with
    #   filters. Useful for applications to build lists, tables, and time series. For a
    #   full list of possible aggregations, see the Query reference.
    # @param count [Fixnum] Number of results to return.
    # @param return_fields [String] A comma-separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results.
    # @param sort [String] A comma-separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified. This
    #   parameter cannot be used in the same query as the **bias** parameter.
    # @param highlight [Boolean] When true, a highlight field is returned for each result which contains the fields
    #   which match the query with `<em></em>` tags around the matching query terms.
    # @param passages_fields [String] A comma-separated list of fields that passages are drawn from. If this parameter
    #   not specified, then all top-level fields are included.
    # @param passages_count [Fixnum] The maximum number of passages to return. The search returns fewer passages if the
    #   requested total is not found. The default is `10`. The maximum is `100`.
    # @param passages_characters [Fixnum] The approximate number of characters that any one passage will have.
    # @param deduplicate [Boolean] When `true`, and used with a Watson Discovery News collection, duplicate results
    #   (based on the contents of the **title** field) are removed. Duplicate comparison
    #   is limited to the current query only; **offset** is not considered. This parameter
    #   is currently Beta functionality.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param collection_ids [String] A comma-separated list of collection IDs to be queried against. Required when
    #   querying multiple collections, invalid when performing a single collection query.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [String] A comma-separated list of document IDs to find similar documents.
    #
    #   **Tip:** Include the **natural_language_query** parameter to expand the scope of
    #   the document similarity search with the natural language query. Other query
    #   parameters, such as **filter** and **query**, are subsequently applied and reduce
    #   the scope.
    # @param similar_fields [String] A comma-separated list of field names that are used as a basis for comparison to
    #   identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @param bias [String] Field which the returned results will be biased against. The specified field must
    #   be either a **date** or **number** format. When a **date** type field is specified
    #   returned results are biased towards field values closer to the current date. When
    #   a **number** type field is specified, returned results are biased towards higher
    #   field values. This parameter cannot be used in the same query as the **sort**
    #   parameter.
    # @param logging_opt_out [Boolean] If `true`, queries are not stored in the Discovery **Logs** endpoint.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate: nil, deduplicate_field: nil, collection_ids: nil, similar: nil, similar_document_ids: nil, similar_fields: nil, bias: nil, logging_opt_out: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
        "X-Watson-Logging-Opt-Out" => logging_opt_out
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "passages" => passages,
        "aggregation" => aggregation,
        "count" => count,
        "return" => return_fields,
        "offset" => offset,
        "sort" => sort,
        "highlight" => highlight,
        "passages.fields" => passages_fields,
        "passages.count" => passages_count,
        "passages.characters" => passages_characters,
        "deduplicate" => deduplicate,
        "deduplicate.field" => deduplicate_field,
        "collection_ids" => collection_ids,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids,
        "similar.fields" => similar_fields,
        "bias" => bias
      }

      method_url = "/v1/environments/%s/collections/%s/query" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method query_notices(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
    # Query system notices.
    # Queries for notices (errors or warnings) that might have been generated by the
    #   system. Notices are generated when ingesting documents and performing relevance
    #   training. See the [Discovery
    #   documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts)
    #   for more details on the query language.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param passages [Boolean] A passages query that returns the most relevant passages from the results.
    # @param aggregation [String] An aggregation search that returns an exact answer by combining query search with
    #   filters. Useful for applications to build lists, tables, and time series. For a
    #   full list of possible aggregations, see the Query reference.
    # @param count [Fixnum] Number of results to return. The maximum for the **count** and **offset** values
    #   together in any one query is **10000**.
    # @param return_fields [Array[String]] A comma-separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results. The maximum for the **count** and **offset** values together in any
    #   one query is **10000**.
    # @param sort [Array[String]] A comma-separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @param highlight [Boolean] When true, a highlight field is returned for each result which contains the fields
    #   which match the query with `<em></em>` tags around the matching query terms.
    # @param passages_fields [Array[String]] A comma-separated list of fields that passages are drawn from. If this parameter
    #   not specified, then all top-level fields are included.
    # @param passages_count [Fixnum] The maximum number of passages to return. The search returns fewer passages if the
    #   requested total is not found.
    # @param passages_characters [Fixnum] The approximate number of characters that any one passage will have.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [Array[String]] A comma-separated list of document IDs to find similar documents.
    #
    #   **Tip:** Include the **natural_language_query** parameter to expand the scope of
    #   the document similarity search with the natural language query. Other query
    #   parameters, such as **filter** and **query**, are subsequently applied and reduce
    #   the scope.
    # @param similar_fields [Array[String]] A comma-separated list of field names that are used as a basis for comparison to
    #   identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query_notices(environment_id:, collection_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "query_notices")
      headers.merge!(sdk_headers)

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
        "deduplicate.field" => deduplicate_field,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids.to_a,
        "similar.fields" => similar_fields.to_a
      }

      method_url = "/v1/environments/%s/collections/%s/notices" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method federated_query(environment_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate: nil, deduplicate_field: nil, collection_ids: nil, similar: nil, similar_document_ids: nil, similar_fields: nil, bias: nil, logging_opt_out: nil)
    # Query multiple collections.
    # By using this method, you can construct long queries that search multiple
    #   collection. For details, see the [Discovery
    #   documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts).
    # @param environment_id [String] The ID of the environment.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first. Use a query search
    #   when you want to find the most relevant search results.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param passages [Boolean] A passages query that returns the most relevant passages from the results.
    # @param aggregation [String] An aggregation search that returns an exact answer by combining query search with
    #   filters. Useful for applications to build lists, tables, and time series. For a
    #   full list of possible aggregations, see the Query reference.
    # @param count [Fixnum] Number of results to return.
    # @param return_fields [String] A comma-separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results.
    # @param sort [String] A comma-separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified. This
    #   parameter cannot be used in the same query as the **bias** parameter.
    # @param highlight [Boolean] When true, a highlight field is returned for each result which contains the fields
    #   which match the query with `<em></em>` tags around the matching query terms.
    # @param passages_fields [String] A comma-separated list of fields that passages are drawn from. If this parameter
    #   not specified, then all top-level fields are included.
    # @param passages_count [Fixnum] The maximum number of passages to return. The search returns fewer passages if the
    #   requested total is not found. The default is `10`. The maximum is `100`.
    # @param passages_characters [Fixnum] The approximate number of characters that any one passage will have.
    # @param deduplicate [Boolean] When `true`, and used with a Watson Discovery News collection, duplicate results
    #   (based on the contents of the **title** field) are removed. Duplicate comparison
    #   is limited to the current query only; **offset** is not considered. This parameter
    #   is currently Beta functionality.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param collection_ids [String] A comma-separated list of collection IDs to be queried against. Required when
    #   querying multiple collections, invalid when performing a single collection query.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [String] A comma-separated list of document IDs to find similar documents.
    #
    #   **Tip:** Include the **natural_language_query** parameter to expand the scope of
    #   the document similarity search with the natural language query. Other query
    #   parameters, such as **filter** and **query**, are subsequently applied and reduce
    #   the scope.
    # @param similar_fields [String] A comma-separated list of field names that are used as a basis for comparison to
    #   identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @param bias [String] Field which the returned results will be biased against. The specified field must
    #   be either a **date** or **number** format. When a **date** type field is specified
    #   returned results are biased towards field values closer to the current date. When
    #   a **number** type field is specified, returned results are biased towards higher
    #   field values. This parameter cannot be used in the same query as the **sort**
    #   parameter.
    # @param logging_opt_out [Boolean] If `true`, queries are not stored in the Discovery **Logs** endpoint.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def federated_query(environment_id:, filter: nil, query: nil, natural_language_query: nil, passages: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, passages_fields: nil, passages_count: nil, passages_characters: nil, deduplicate: nil, deduplicate_field: nil, collection_ids: nil, similar: nil, similar_document_ids: nil, similar_fields: nil, bias: nil, logging_opt_out: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
        "X-Watson-Logging-Opt-Out" => logging_opt_out
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "federated_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "passages" => passages,
        "aggregation" => aggregation,
        "count" => count,
        "return" => return_fields,
        "offset" => offset,
        "sort" => sort,
        "highlight" => highlight,
        "passages.fields" => passages_fields,
        "passages.count" => passages_count,
        "passages.characters" => passages_characters,
        "deduplicate" => deduplicate,
        "deduplicate.field" => deduplicate_field,
        "collection_ids" => collection_ids,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids,
        "similar.fields" => similar_fields,
        "bias" => bias
      }

      method_url = "/v1/environments/%s/query" % [ERB::Util.url_encode(environment_id)]

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
    # @!method federated_query_notices(environment_id:, collection_ids:, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
    # Query multiple collection system notices.
    # Queries for notices (errors or warnings) that might have been generated by the
    #   system. Notices are generated when ingesting documents and performing relevance
    #   training. See the [Discovery
    #   documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-query-concepts#query-concepts)
    #   for more details on the query language.
    # @param environment_id [String] The ID of the environment.
    # @param collection_ids [Array[String]] A comma-separated list of collection IDs to be queried against.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first.
    # @param natural_language_query [String] A natural language query that returns relevant documents by utilizing training
    #   data and natural language understanding.
    # @param aggregation [String] An aggregation search that returns an exact answer by combining query search with
    #   filters. Useful for applications to build lists, tables, and time series. For a
    #   full list of possible aggregations, see the Query reference.
    # @param count [Fixnum] Number of results to return. The maximum for the **count** and **offset** values
    #   together in any one query is **10000**.
    # @param return_fields [Array[String]] A comma-separated list of the portion of the document hierarchy to return.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results. The maximum for the **count** and **offset** values together in any
    #   one query is **10000**.
    # @param sort [Array[String]] A comma-separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @param highlight [Boolean] When true, a highlight field is returned for each result which contains the fields
    #   which match the query with `<em></em>` tags around the matching query terms.
    # @param deduplicate_field [String] When specified, duplicate results based on the field specified are removed from
    #   the returned results. Duplicate comparison is limited to the current query only,
    #   **offset** is not considered. This parameter is currently Beta functionality.
    # @param similar [Boolean] When `true`, results are returned based on their similarity to the document IDs
    #   specified in the **similar.document_ids** parameter.
    # @param similar_document_ids [Array[String]] A comma-separated list of document IDs to find similar documents.
    #
    #   **Tip:** Include the **natural_language_query** parameter to expand the scope of
    #   the document similarity search with the natural language query. Other query
    #   parameters, such as **filter** and **query**, are subsequently applied and reduce
    #   the scope.
    # @param similar_fields [Array[String]] A comma-separated list of field names that are used as a basis for comparison to
    #   identify similar documents. If not specified, the entire document is used for
    #   comparison.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def federated_query_notices(environment_id:, collection_ids:, filter: nil, query: nil, natural_language_query: nil, aggregation: nil, count: nil, return_fields: nil, offset: nil, sort: nil, highlight: nil, deduplicate_field: nil, similar: nil, similar_document_ids: nil, similar_fields: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_ids must be provided") if collection_ids.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "federated_query_notices")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "collection_ids" => collection_ids.to_a,
        "filter" => filter,
        "query" => query,
        "natural_language_query" => natural_language_query,
        "aggregation" => aggregation,
        "count" => count,
        "return" => return_fields.to_a,
        "offset" => offset,
        "sort" => sort.to_a,
        "highlight" => highlight,
        "deduplicate.field" => deduplicate_field,
        "similar" => similar,
        "similar.document_ids" => similar_document_ids.to_a,
        "similar.fields" => similar_fields.to_a
      }

      method_url = "/v1/environments/%s/notices" % [ERB::Util.url_encode(environment_id)]

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
    #   documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-kg#kg)
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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query_entities(environment_id:, collection_id:, feature: nil, entity: nil, context: nil, count: nil, evidence_count: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "query_entities")
      headers.merge!(sdk_headers)

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

      method_url = "/v1/environments/%s/collections/%s/query_entities" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    #   documentation](https://cloud.ibm.com/docs/services/discovery?topic=discovery-kg#kg)
    #   for more details.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param entities [Array[QueryRelationsEntity]] An array of entities to find relationships for.
    # @param context [QueryEntitiesContext] Entity text to provide context for the queried entity and rank based on that
    #   association. For example, if you wanted to query the city of London in England
    #   your query would look for `London` with the context of `England`.
    # @param sort [String] The sorting method for the relationships, can be `score` or `frequency`.
    #   `frequency` is the number of unique times each entity is identified. The default
    #   is `score`. This parameter cannot be used in the same query as the **bias**
    #   parameter.
    # @param filter [QueryRelationsFilter]
    # @param count [Fixnum] The number of results to return. The default is `10`. The maximum is `1000`.
    # @param evidence_count [Fixnum] The number of evidence items to return for each result. The default is `0`. The
    #   maximum number of evidence items per query is 10,000.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query_relations(environment_id:, collection_id:, entities: nil, context: nil, sort: nil, filter: nil, count: nil, evidence_count: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "query_relations")
      headers.merge!(sdk_headers)

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

      method_url = "/v1/environments/%s/collections/%s/query_relations" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_training_data(environment_id:, collection_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_training_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/training_data" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @param natural_language_query [String] The natural text query for the new training query.
    # @param filter [String] The filter used on the collection before the **natural_language_query** is
    #   applied.
    # @param examples [Array[TrainingExample]] Array of training examples.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def add_training_data(environment_id:, collection_id:, natural_language_query: nil, filter: nil, examples: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "add_training_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "natural_language_query" => natural_language_query,
        "filter" => filter,
        "examples" => examples
      }

      method_url = "/v1/environments/%s/collections/%s/training_data" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_all_training_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/training_data" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id)]

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
    # @!method get_training_data(environment_id:, collection_id:, query_id:)
    # Get details about a query.
    # Gets details for a specific training data query, including the query string and
    #   all examples.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_training_data(environment_id:, collection_id:, query_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_training_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/training_data/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(query_id)]

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
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_training_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/training_data/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(query_id)]

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
    # @!method list_training_examples(environment_id:, collection_id:, query_id:)
    # List examples for a training data query.
    # List all examples for this training data query.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_training_examples(environment_id:, collection_id:, query_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_training_examples")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(query_id)]

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
    # @param document_id [String] The document ID associated with this training example.
    # @param cross_reference [String] The cross reference associated with this training example.
    # @param relevance [Fixnum] The relevance of the training example.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_training_example(environment_id:, collection_id:, query_id:, document_id: nil, cross_reference: nil, relevance: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_training_example")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "document_id" => document_id,
        "cross_reference" => cross_reference,
        "relevance" => relevance
      }

      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(query_id)]

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
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      raise ArgumentError.new("example_id must be provided") if example_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_training_example")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(query_id), ERB::Util.url_encode(example_id)]

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
    # @!method update_training_example(environment_id:, collection_id:, query_id:, example_id:, cross_reference: nil, relevance: nil)
    # Change label or cross reference for example.
    # Changes the label or cross reference query for this training data example.
    # @param environment_id [String] The ID of the environment.
    # @param collection_id [String] The ID of the collection.
    # @param query_id [String] The ID of the query used for training.
    # @param example_id [String] The ID of the document as it is indexed.
    # @param cross_reference [String] The example to add.
    # @param relevance [Fixnum] The relevance value for this example.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_training_example(environment_id:, collection_id:, query_id:, example_id:, cross_reference: nil, relevance: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      raise ArgumentError.new("example_id must be provided") if example_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "update_training_example")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "cross_reference" => cross_reference,
        "relevance" => relevance
      }

      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(query_id), ERB::Util.url_encode(example_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_training_example(environment_id:, collection_id:, query_id:, example_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("query_id must be provided") if query_id.nil?

      raise ArgumentError.new("example_id must be provided") if example_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_training_example")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/collections/%s/training_data/%s/examples/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(collection_id), ERB::Util.url_encode(query_id), ERB::Util.url_encode(example_id)]

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
    #   security](https://cloud.ibm.com/docs/services/discovery?topic=discovery-information-security#information-security).
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError.new("customer_id must be provided") if customer_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_user_data")
      headers.merge!(sdk_headers)

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
        accept_json: false
      )
      nil
    end
    #########################
    # Events and feedback
    #########################

    ##
    # @!method create_event(type:, data:)
    # Create event.
    # The **Events** API can be used to create log entries that are associated with
    #   specific queries. For example, you can record which documents in the results set
    #   were \"clicked\" by a user and when that click occured.
    # @param type [String] The event type to be created.
    # @param data [EventData] Query event data object.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_event(type:, data:)
      raise ArgumentError.new("type must be provided") if type.nil?

      raise ArgumentError.new("data must be provided") if data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_event")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "type" => type,
        "data" => data
      }

      method_url = "/v1/events"

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
    # @!method query_log(filter: nil, query: nil, count: nil, offset: nil, sort: nil)
    # Search the query and event log.
    # Searches the query and event log to find query sessions that match the specified
    #   criteria. Searching the **logs** endpoint uses the standard Discovery query syntax
    #   for the parameters that are supported.
    # @param filter [String] A cacheable query that excludes documents that don't mention the query content.
    #   Filter searches are better for metadata-type searches and for assessing the
    #   concepts in the data set.
    # @param query [String] A query search returns all documents in your data set with full enrichments and
    #   full text, but with the most relevant documents listed first.
    # @param count [Fixnum] Number of results to return. The maximum for the **count** and **offset** values
    #   together in any one query is **10000**.
    # @param offset [Fixnum] The number of query results to skip at the beginning. For example, if the total
    #   number of results that are returned is 10 and the offset is 8, it returns the last
    #   two results. The maximum for the **count** and **offset** values together in any
    #   one query is **10000**.
    # @param sort [Array[String]] A comma-separated list of fields in the document to sort on. You can optionally
    #   specify a sort direction by prefixing the field with `-` for descending or `+` for
    #   ascending. Ascending is the default sort direction if no prefix is specified.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def query_log(filter: nil, query: nil, count: nil, offset: nil, sort: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "query_log")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "filter" => filter,
        "query" => query,
        "count" => count,
        "offset" => offset,
        "sort" => sort.to_a
      }

      method_url = "/v1/logs"

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
    # @!method get_metrics_query(start_time: nil, end_time: nil, result_type: nil)
    # Number of queries over time.
    # Total number of queries using the **natural_language_query** parameter over a
    #   specific time window.
    # @param start_time [Time] Metric is computed from data recorded after this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param end_time [Time] Metric is computed from data recorded before this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param result_type [String] The type of result to consider when calculating the metric.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_metrics_query(start_time: nil, end_time: nil, result_type: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_metrics_query")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "start_time" => start_time,
        "end_time" => end_time,
        "result_type" => result_type
      }

      method_url = "/v1/metrics/number_of_queries"

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
    # @!method get_metrics_query_event(start_time: nil, end_time: nil, result_type: nil)
    # Number of queries with an event over time.
    # Total number of queries using the **natural_language_query** parameter that have a
    #   corresponding \"click\" event over a specified time window. This metric requires
    #   having integrated event tracking in your application using the **Events** API.
    # @param start_time [Time] Metric is computed from data recorded after this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param end_time [Time] Metric is computed from data recorded before this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param result_type [String] The type of result to consider when calculating the metric.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_metrics_query_event(start_time: nil, end_time: nil, result_type: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_metrics_query_event")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "start_time" => start_time,
        "end_time" => end_time,
        "result_type" => result_type
      }

      method_url = "/v1/metrics/number_of_queries_with_event"

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
    # @!method get_metrics_query_no_results(start_time: nil, end_time: nil, result_type: nil)
    # Number of queries with no search results over time.
    # Total number of queries using the **natural_language_query** parameter that have
    #   no results returned over a specified time window.
    # @param start_time [Time] Metric is computed from data recorded after this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param end_time [Time] Metric is computed from data recorded before this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param result_type [String] The type of result to consider when calculating the metric.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_metrics_query_no_results(start_time: nil, end_time: nil, result_type: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_metrics_query_no_results")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "start_time" => start_time,
        "end_time" => end_time,
        "result_type" => result_type
      }

      method_url = "/v1/metrics/number_of_queries_with_no_search_results"

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
    # @!method get_metrics_event_rate(start_time: nil, end_time: nil, result_type: nil)
    # Percentage of queries with an associated event.
    # The percentage of queries using the **natural_language_query** parameter that have
    #   a corresponding \"click\" event over a specified time window.  This metric
    #   requires having integrated event tracking in your application using the **Events**
    #   API.
    # @param start_time [Time] Metric is computed from data recorded after this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param end_time [Time] Metric is computed from data recorded before this timestamp; must be in
    #   `YYYY-MM-DDThh:mm:ssZ` format.
    # @param result_type [String] The type of result to consider when calculating the metric.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_metrics_event_rate(start_time: nil, end_time: nil, result_type: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_metrics_event_rate")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "start_time" => start_time,
        "end_time" => end_time,
        "result_type" => result_type
      }

      method_url = "/v1/metrics/event_rate"

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
    # @!method get_metrics_query_token_event(count: nil)
    # Most frequent query tokens with an event.
    # The most frequent query tokens parsed from the **natural_language_query**
    #   parameter and their corresponding \"click\" event rate within the recording period
    #   (queries and events are stored for 30 days). A query token is an individual word
    #   or unigram within the query string.
    # @param count [Fixnum] Number of results to return. The maximum for the **count** and **offset** values
    #   together in any one query is **10000**.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_metrics_query_token_event(count: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_metrics_query_token_event")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "count" => count
      }

      method_url = "/v1/metrics/top_query_tokens_with_event_rate"

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_credentials(environment_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_credentials")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/credentials" % [ERB::Util.url_encode(environment_id)]

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
    # @!method create_credentials(environment_id:, source_type: nil, credential_details: nil, status: nil)
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
    #   -  `web_crawl` indicates the credentials are used to perform a web crawl.
    #   =  `cloud_object_storage` indicates the credentials are used to connect to an IBM
    #   Cloud Object Store.
    # @param credential_details [CredentialDetails] Object containing details of the stored credentials.
    #
    #   Obtain credentials for your source from the administrator of the source.
    # @param status [String] The current status of this set of credentials. `connected` indicates that the
    #   credentials are available to use with the source configuration of a collection.
    #   `invalid` refers to the credentials (for example, the password provided has
    #   expired) and must be corrected before they can be used with a collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_credentials(environment_id:, source_type: nil, credential_details: nil, status: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_credentials")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "source_type" => source_type,
        "credential_details" => credential_details,
        "status" => status
      }

      method_url = "/v1/environments/%s/credentials" % [ERB::Util.url_encode(environment_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_credentials(environment_id:, credential_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("credential_id must be provided") if credential_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_credentials")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/credentials/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(credential_id)]

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
    # @!method update_credentials(environment_id:, credential_id:, source_type: nil, credential_details: nil, status: nil)
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
    #   -  `web_crawl` indicates the credentials are used to perform a web crawl.
    #   =  `cloud_object_storage` indicates the credentials are used to connect to an IBM
    #   Cloud Object Store.
    # @param credential_details [CredentialDetails] Object containing details of the stored credentials.
    #
    #   Obtain credentials for your source from the administrator of the source.
    # @param status [String] The current status of this set of credentials. `connected` indicates that the
    #   credentials are available to use with the source configuration of a collection.
    #   `invalid` refers to the credentials (for example, the password provided has
    #   expired) and must be corrected before they can be used with a collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_credentials(environment_id:, credential_id:, source_type: nil, credential_details: nil, status: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("credential_id must be provided") if credential_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "update_credentials")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "source_type" => source_type,
        "credential_details" => credential_details,
        "status" => status
      }

      method_url = "/v1/environments/%s/credentials/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(credential_id)]

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
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_credentials(environment_id:, credential_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("credential_id must be provided") if credential_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_credentials")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/credentials/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(credential_id)]

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
    # gatewayConfiguration
    #########################

    ##
    # @!method list_gateways(environment_id:)
    # List Gateways.
    # List the currently configured gateways.
    # @param environment_id [String] The ID of the environment.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_gateways(environment_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "list_gateways")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/gateways" % [ERB::Util.url_encode(environment_id)]

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
    # @!method create_gateway(environment_id:, name: nil)
    # Create Gateway.
    # Create a gateway configuration to use with a remotely installed gateway.
    # @param environment_id [String] The ID of the environment.
    # @param name [String] User-defined name.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_gateway(environment_id:, name: nil)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "create_gateway")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name
      }

      method_url = "/v1/environments/%s/gateways" % [ERB::Util.url_encode(environment_id)]

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
    # @!method get_gateway(environment_id:, gateway_id:)
    # List Gateway Details.
    # List information about the specified gateway.
    # @param environment_id [String] The ID of the environment.
    # @param gateway_id [String] The requested gateway ID.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_gateway(environment_id:, gateway_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("gateway_id must be provided") if gateway_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "get_gateway")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/gateways/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(gateway_id)]

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
    # @!method delete_gateway(environment_id:, gateway_id:)
    # Delete Gateway.
    # Delete the specified gateway configuration.
    # @param environment_id [String] The ID of the environment.
    # @param gateway_id [String] The requested gateway ID.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_gateway(environment_id:, gateway_id:)
      raise ArgumentError.new("environment_id must be provided") if environment_id.nil?

      raise ArgumentError.new("gateway_id must be provided") if gateway_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("discovery", "V1", "delete_gateway")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/environments/%s/gateways/%s" % [ERB::Util.url_encode(environment_id), ERB::Util.url_encode(gateway_id)]

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
