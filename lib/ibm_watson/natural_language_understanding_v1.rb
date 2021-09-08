# frozen_string_literal: true

# (C) Copyright IBM Corp. 2018, 2020.
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
# Analyze various features of text content at scale. Provide text, raw HTML, or a public
# URL and IBM Watson Natural Language Understanding will give you results for the features
# you request. The service cleans HTML content before analysis by default, so the results
# can ignore most advertisements and other unwanted content.
#
# You can create [custom
# models](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-customizing)
# with Watson Knowledge Studio to detect custom entities and relations in Natural Language
# Understanding.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

module IBMWatson
  ##
  # The Natural Language Understanding V1 service.
  class NaturalLanguageUnderstandingV1 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    DEFAULT_SERVICE_NAME = "natural_language_understanding"
    DEFAULT_SERVICE_URL = "https://api.us-south.natural-language-understanding.watson.cloud.ibm.com"
    attr_accessor :version
    ##
    # @!method initialize(args)
    # Construct a new client for the Natural Language Understanding service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] Release date of the API version you want to use. Specify dates in YYYY-MM-DD
    #   format. The current version is `2021-08-01`.
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
    # Analyze
    #########################

    ##
    # @!method analyze(features:, text: nil, html: nil, url: nil, clean: nil, xpath: nil, fallback_to_raw: nil, return_analyzed_text: nil, language: nil, limit_text_characters: nil)
    # Analyze text.
    # Analyzes text, HTML, or a public webpage for the following features:
    #   - Categories
    #   - Classifications
    #   - Concepts
    #   - Emotion
    #   - Entities
    #   - Keywords
    #   - Metadata
    #   - Relations
    #   - Semantic roles
    #   - Sentiment
    #   - Syntax
    #   - Summarization (Experimental)
    #
    #   If a language for the input text is not specified with the `language` parameter,
    #   the service [automatically detects the
    #   language](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-detectable-languages).
    # @param features [Features] Specific features to analyze the document for.
    # @param text [String] The plain text to analyze. One of the `text`, `html`, or `url` parameters is
    #   required.
    # @param html [String] The HTML file to analyze. One of the `text`, `html`, or `url` parameters is
    #   required.
    # @param url [String] The webpage to analyze. One of the `text`, `html`, or `url` parameters is
    #   required.
    # @param clean [Boolean] Set this to `false` to disable webpage cleaning. For more information about
    #   webpage cleaning, see [Analyzing
    #   webpages](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-analyzing-webpages).
    # @param xpath [String] An [XPath
    #   query](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-analyzing-webpages#xpath)
    #   to perform on `html` or `url` input. Results of the query will be appended to the
    #   cleaned webpage text before it is analyzed. To analyze only the results of the
    #   XPath query, set the `clean` parameter to `false`.
    # @param fallback_to_raw [Boolean] Whether to use raw HTML content if text cleaning fails.
    # @param return_analyzed_text [Boolean] Whether or not to return the analyzed text.
    # @param language [String] ISO 639-1 code that specifies the language of your text. This overrides automatic
    #   language detection. Language support differs depending on the features you include
    #   in your analysis. For more information, see [Language
    #   support](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-language-support).
    # @param limit_text_characters [Fixnum] Sets the maximum number of characters that are processed by the service.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def analyze(features:, text: nil, html: nil, url: nil, clean: nil, xpath: nil, fallback_to_raw: nil, return_analyzed_text: nil, language: nil, limit_text_characters: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("features must be provided") if features.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "analyze")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "features" => features,
        "text" => text,
        "html" => html,
        "url" => url,
        "clean" => clean,
        "xpath" => xpath,
        "fallback_to_raw" => fallback_to_raw,
        "return_analyzed_text" => return_analyzed_text,
        "language" => language,
        "limit_text_characters" => limit_text_characters
      }

      method_url = "/v1/analyze"

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
    # Manage models
    #########################

    ##
    # @!method list_models
    # List models.
    # Lists Watson Knowledge Studio [custom entities and relations
    #   models](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-customizing)
    #   that are deployed to your Natural Language Understanding service.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_models
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "list_models")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models"

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
    # @!method delete_model(model_id:)
    # Delete model.
    # Deletes a custom model.
    # @param model_id [String] Model ID of the model to delete.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "delete_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/%s" % [ERB::Util.url_encode(model_id)]

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
    # Manage sentiment models
    #########################

    ##
    # @!method create_sentiment_model(language:, training_data:, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
    # Create sentiment model.
    # (Beta) Creates a custom sentiment model by uploading training data and associated
    #   metadata. The model begins the training and deploying process and is ready to use
    #   when the `status` is `available`.
    # @param language [String] The 2-letter language code of this model.
    # @param training_data [File] Training data in CSV format. For more information, see [Sentiment training data
    #   requirements](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-custom-sentiment#sentiment-training-data-requirements).
    # @param name [String] An optional name for the model.
    # @param description [String] An optional description of the model.
    # @param model_version [String] An optional version string.
    # @param workspace_id [String] ID of the Watson Knowledge Studio workspace that deployed this model to Natural
    #   Language Understanding.
    # @param version_description [String] The description of the version.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_sentiment_model(language:, training_data:, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("language must be provided") if language.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "create_sentiment_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:language] = HTTP::FormData::Part.new(language.to_s, content_type: "text/plain")

      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      form_data[:training_data] = HTTP::FormData::File.new(training_data, content_type: "text/csv", filename: training_data.respond_to?(:path) ? training_data.path : nil)

      form_data[:name] = HTTP::FormData::Part.new(name.to_s, content_type: "text/plain") unless name.nil?

      form_data[:description] = HTTP::FormData::Part.new(description.to_s, content_type: "text/plain") unless description.nil?

      form_data[:model_version] = HTTP::FormData::Part.new(model_version.to_s, content_type: "text/plain") unless model_version.nil?

      form_data[:workspace_id] = HTTP::FormData::Part.new(workspace_id.to_s, content_type: "text/plain") unless workspace_id.nil?

      form_data[:version_description] = HTTP::FormData::Part.new(version_description.to_s, content_type: "text/plain") unless version_description.nil?

      method_url = "/v1/models/sentiment"

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
    # @!method list_sentiment_models
    # List sentiment models.
    # (Beta) Returns all custom sentiment models associated with this service instance.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_sentiment_models
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "list_sentiment_models")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/sentiment"

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
    # @!method get_sentiment_model(model_id:)
    # Get sentiment model details.
    # (Beta) Returns the status of the sentiment model with the given model ID.
    # @param model_id [String] ID of the model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_sentiment_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "get_sentiment_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/sentiment/%s" % [ERB::Util.url_encode(model_id)]

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
    # @!method update_sentiment_model(model_id:, language:, training_data:, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
    # Update sentiment model.
    # (Beta) Overwrites the training data associated with this custom sentiment model
    #   and retrains the model. The new model replaces the current deployment.
    # @param model_id [String] ID of the model.
    # @param language [String] The 2-letter language code of this model.
    # @param training_data [File] Training data in CSV format. For more information, see [Sentiment training data
    #   requirements](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-custom-sentiment#sentiment-training-data-requirements).
    # @param name [String] An optional name for the model.
    # @param description [String] An optional description of the model.
    # @param model_version [String] An optional version string.
    # @param workspace_id [String] ID of the Watson Knowledge Studio workspace that deployed this model to Natural
    #   Language Understanding.
    # @param version_description [String] The description of the version.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_sentiment_model(model_id:, language:, training_data:, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      raise ArgumentError.new("language must be provided") if language.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "update_sentiment_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:language] = HTTP::FormData::Part.new(language.to_s, content_type: "text/plain")

      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      form_data[:training_data] = HTTP::FormData::File.new(training_data, content_type: "text/csv", filename: training_data.respond_to?(:path) ? training_data.path : nil)

      form_data[:name] = HTTP::FormData::Part.new(name.to_s, content_type: "text/plain") unless name.nil?

      form_data[:description] = HTTP::FormData::Part.new(description.to_s, content_type: "text/plain") unless description.nil?

      form_data[:model_version] = HTTP::FormData::Part.new(model_version.to_s, content_type: "text/plain") unless model_version.nil?

      form_data[:workspace_id] = HTTP::FormData::Part.new(workspace_id.to_s, content_type: "text/plain") unless workspace_id.nil?

      form_data[:version_description] = HTTP::FormData::Part.new(version_description.to_s, content_type: "text/plain") unless version_description.nil?

      method_url = "/v1/models/sentiment/%s" % [ERB::Util.url_encode(model_id)]

      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_sentiment_model(model_id:)
    # Delete sentiment model.
    # (Beta) Un-deploys the custom sentiment model with the given model ID and deletes
    #   all associated customer data, including any training data or binary artifacts.
    # @param model_id [String] ID of the model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_sentiment_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "delete_sentiment_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/sentiment/%s" % [ERB::Util.url_encode(model_id)]

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
    # Manage categories models
    #########################

    ##
    # @!method create_categories_model(language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
    # Create categories model.
    # (Beta) Creates a custom categories model by uploading training data and associated
    #   metadata. The model begins the training and deploying process and is ready to use
    #   when the `status` is `available`.
    # @param language [String] The 2-letter language code of this model.
    # @param training_data [File] Training data in JSON format. For more information, see [Categories training data
    #   requirements](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-categories##categories-training-data-requirements).
    # @param training_data_content_type [String] The content type of training_data.
    # @param name [String] An optional name for the model.
    # @param description [String] An optional description of the model.
    # @param model_version [String] An optional version string.
    # @param workspace_id [String] ID of the Watson Knowledge Studio workspace that deployed this model to Natural
    #   Language Understanding.
    # @param version_description [String] The description of the version.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_categories_model(language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("language must be provided") if language.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "create_categories_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:language] = HTTP::FormData::Part.new(language.to_s, content_type: "text/plain")

      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      form_data[:training_data] = HTTP::FormData::File.new(training_data, content_type: training_data_content_type.nil? ? "application/octet-stream" : training_data_content_type, filename: training_data.respond_to?(:path) ? training_data.path : nil)

      form_data[:name] = HTTP::FormData::Part.new(name.to_s, content_type: "text/plain") unless name.nil?

      form_data[:description] = HTTP::FormData::Part.new(description.to_s, content_type: "text/plain") unless description.nil?

      form_data[:model_version] = HTTP::FormData::Part.new(model_version.to_s, content_type: "text/plain") unless model_version.nil?

      form_data[:workspace_id] = HTTP::FormData::Part.new(workspace_id.to_s, content_type: "text/plain") unless workspace_id.nil?

      form_data[:version_description] = HTTP::FormData::Part.new(version_description.to_s, content_type: "text/plain") unless version_description.nil?

      method_url = "/v1/models/categories"

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
    # @!method list_categories_models
    # List categories models.
    # (Beta) Returns all custom categories models associated with this service instance.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_categories_models
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "list_categories_models")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/categories"

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
    # @!method get_categories_model(model_id:)
    # Get categories model details.
    # (Beta) Returns the status of the categories model with the given model ID.
    # @param model_id [String] ID of the model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_categories_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "get_categories_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/categories/%s" % [ERB::Util.url_encode(model_id)]

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
    # @!method update_categories_model(model_id:, language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
    # Update categories model.
    # (Beta) Overwrites the training data associated with this custom categories model
    #   and retrains the model. The new model replaces the current deployment.
    # @param model_id [String] ID of the model.
    # @param language [String] The 2-letter language code of this model.
    # @param training_data [File] Training data in JSON format. For more information, see [Categories training data
    #   requirements](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-categories##categories-training-data-requirements).
    # @param training_data_content_type [String] The content type of training_data.
    # @param name [String] An optional name for the model.
    # @param description [String] An optional description of the model.
    # @param model_version [String] An optional version string.
    # @param workspace_id [String] ID of the Watson Knowledge Studio workspace that deployed this model to Natural
    #   Language Understanding.
    # @param version_description [String] The description of the version.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_categories_model(model_id:, language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      raise ArgumentError.new("language must be provided") if language.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "update_categories_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:language] = HTTP::FormData::Part.new(language.to_s, content_type: "text/plain")

      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      form_data[:training_data] = HTTP::FormData::File.new(training_data, content_type: training_data_content_type.nil? ? "application/octet-stream" : training_data_content_type, filename: training_data.respond_to?(:path) ? training_data.path : nil)

      form_data[:name] = HTTP::FormData::Part.new(name.to_s, content_type: "text/plain") unless name.nil?

      form_data[:description] = HTTP::FormData::Part.new(description.to_s, content_type: "text/plain") unless description.nil?

      form_data[:model_version] = HTTP::FormData::Part.new(model_version.to_s, content_type: "text/plain") unless model_version.nil?

      form_data[:workspace_id] = HTTP::FormData::Part.new(workspace_id.to_s, content_type: "text/plain") unless workspace_id.nil?

      form_data[:version_description] = HTTP::FormData::Part.new(version_description.to_s, content_type: "text/plain") unless version_description.nil?

      method_url = "/v1/models/categories/%s" % [ERB::Util.url_encode(model_id)]

      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_categories_model(model_id:)
    # Delete categories model.
    # (Beta) Un-deploys the custom categories model with the given model ID and deletes
    #   all associated customer data, including any training data or binary artifacts.
    # @param model_id [String] ID of the model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_categories_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "delete_categories_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/categories/%s" % [ERB::Util.url_encode(model_id)]

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
    # Manage classifications models
    #########################

    ##
    # @!method create_classifications_model(language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
    # Create classifications model.
    # Creates a custom classifications model by uploading training data and associated
    #   metadata. The model begins the training and deploying process and is ready to use
    #   when the `status` is `available`.
    # @param language [String] The 2-letter language code of this model.
    # @param training_data [File] Training data in JSON format. For more information, see [Classifications training
    #   data
    #   requirements](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-classifications#classification-training-data-requirements).
    # @param training_data_content_type [String] The content type of training_data.
    # @param name [String] An optional name for the model.
    # @param description [String] An optional description of the model.
    # @param model_version [String] An optional version string.
    # @param workspace_id [String] ID of the Watson Knowledge Studio workspace that deployed this model to Natural
    #   Language Understanding.
    # @param version_description [String] The description of the version.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_classifications_model(language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("language must be provided") if language.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "create_classifications_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:language] = HTTP::FormData::Part.new(language.to_s, content_type: "text/plain")

      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      form_data[:training_data] = HTTP::FormData::File.new(training_data, content_type: training_data_content_type.nil? ? "application/octet-stream" : training_data_content_type, filename: training_data.respond_to?(:path) ? training_data.path : nil)

      form_data[:name] = HTTP::FormData::Part.new(name.to_s, content_type: "text/plain") unless name.nil?

      form_data[:description] = HTTP::FormData::Part.new(description.to_s, content_type: "text/plain") unless description.nil?

      form_data[:model_version] = HTTP::FormData::Part.new(model_version.to_s, content_type: "text/plain") unless model_version.nil?

      form_data[:workspace_id] = HTTP::FormData::Part.new(workspace_id.to_s, content_type: "text/plain") unless workspace_id.nil?

      form_data[:version_description] = HTTP::FormData::Part.new(version_description.to_s, content_type: "text/plain") unless version_description.nil?

      method_url = "/v1/models/classifications"

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
    # @!method list_classifications_models
    # List classifications models.
    # Returns all custom classifications models associated with this service instance.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_classifications_models
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "list_classifications_models")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/classifications"

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
    # @!method get_classifications_model(model_id:)
    # Get classifications model details.
    # Returns the status of the classifications model with the given model ID.
    # @param model_id [String] ID of the model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_classifications_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "get_classifications_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/classifications/%s" % [ERB::Util.url_encode(model_id)]

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
    # @!method update_classifications_model(model_id:, language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
    # Update classifications model.
    # Overwrites the training data associated with this custom classifications model and
    #   retrains the model. The new model replaces the current deployment.
    # @param model_id [String] ID of the model.
    # @param language [String] The 2-letter language code of this model.
    # @param training_data [File] Training data in JSON format. For more information, see [Classifications training
    #   data
    #   requirements](https://cloud.ibm.com/docs/natural-language-understanding?topic=natural-language-understanding-classifications#classification-training-data-requirements).
    # @param training_data_content_type [String] The content type of training_data.
    # @param name [String] An optional name for the model.
    # @param description [String] An optional description of the model.
    # @param model_version [String] An optional version string.
    # @param workspace_id [String] ID of the Watson Knowledge Studio workspace that deployed this model to Natural
    #   Language Understanding.
    # @param version_description [String] The description of the version.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_classifications_model(model_id:, language:, training_data:, training_data_content_type: nil, name: nil, description: nil, model_version: nil, workspace_id: nil, version_description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      raise ArgumentError.new("language must be provided") if language.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "update_classifications_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:language] = HTTP::FormData::Part.new(language.to_s, content_type: "text/plain")

      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      form_data[:training_data] = HTTP::FormData::File.new(training_data, content_type: training_data_content_type.nil? ? "application/octet-stream" : training_data_content_type, filename: training_data.respond_to?(:path) ? training_data.path : nil)

      form_data[:name] = HTTP::FormData::Part.new(name.to_s, content_type: "text/plain") unless name.nil?

      form_data[:description] = HTTP::FormData::Part.new(description.to_s, content_type: "text/plain") unless description.nil?

      form_data[:model_version] = HTTP::FormData::Part.new(model_version.to_s, content_type: "text/plain") unless model_version.nil?

      form_data[:workspace_id] = HTTP::FormData::Part.new(workspace_id.to_s, content_type: "text/plain") unless workspace_id.nil?

      form_data[:version_description] = HTTP::FormData::Part.new(version_description.to_s, content_type: "text/plain") unless version_description.nil?

      method_url = "/v1/models/classifications/%s" % [ERB::Util.url_encode(model_id)]

      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_classifications_model(model_id:)
    # Delete classifications model.
    # Un-deploys the custom classifications model with the given model ID and deletes
    #   all associated customer data, including any training data or binary artifacts.
    # @param model_id [String] ID of the model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_classifications_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural-language-understanding", "V1", "delete_classifications_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/models/classifications/%s" % [ERB::Util.url_encode(model_id)]

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
