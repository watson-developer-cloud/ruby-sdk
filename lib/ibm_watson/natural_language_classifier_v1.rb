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

# IBM Watson&trade; Natural Language Classifier uses machine learning algorithms to
# return the top matching predefined classes for short text input. You create and train a
# classifier to connect predefined classes to example texts so that the service can apply
# those classes to new inputs.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Natural Language Classifier V1 service.
  class NaturalLanguageClassifierV1 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Natural Language Classifier service.
    #
    # @param args [Hash] The args to initialize with
    # @option args url [String] The base url to use when contacting the service (e.g.
    #   "https://gateway.watsonplatform.net/natural-language-classifier/api").
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
    # @option args icp4d_access_token [STRING]  A ICP4D(IBM Cloud Pak for Data) access token is
    #   fully managed by the application. Responsibility falls on the application to
    #   refresh the token, either before it expires or reactively upon receiving a 401
    #   from the service as any requests made with an expired token will fail.
    # @option args icp4d_url [STRING] In order to use an SDK-managed token with ICP4D authentication, this
    #   URL must be passed in.
    # @option args authentication_type [STRING] Specifies the authentication pattern to use. Values that it
    #   takes are basic, iam or icp4d.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:url] = "https://gateway.watsonplatform.net/natural-language-classifier/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      defaults[:iam_client_id] = nil
      defaults[:iam_client_secret] = nil
      defaults[:icp4d_access_token] = nil
      defaults[:icp4d_url] = nil
      defaults[:authentication_type] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "natural_language_classifier"
      super
      args[:display_name] = "Natural Language Classifier"
    end

    #########################
    # Classify text
    #########################

    ##
    # @!method classify(classifier_id:, text:)
    # Classify a phrase.
    # Returns label information for the input. The status must be `Available` before you
    #   can use the classifier to classify text.
    # @param classifier_id [String] Classifier ID to use.
    # @param text [String] The submitted phrase. The maximum length is 2048 characters.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def classify(classifier_id:, text:)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      raise ArgumentError.new("text must be provided") if text.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural_language_classifier", "V1", "classify")
      headers.merge!(sdk_headers)

      data = {
        "text" => text
      }

      method_url = "/v1/classifiers/%s/classify" % [ERB::Util.url_encode(classifier_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        json: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method classify_collection(classifier_id:, collection:)
    # Classify multiple phrases.
    # Returns label information for multiple phrases. The status must be `Available`
    #   before you can use the classifier to classify text.
    #
    #   Note that classifying Japanese texts is a beta feature.
    # @param classifier_id [String] Classifier ID to use.
    # @param collection [Array[ClassifyInput]] The submitted phrases.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def classify_collection(classifier_id:, collection:)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      raise ArgumentError.new("collection must be provided") if collection.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural_language_classifier", "V1", "classify_collection")
      headers.merge!(sdk_headers)

      data = {
        "collection" => collection
      }

      method_url = "/v1/classifiers/%s/classify_collection" % [ERB::Util.url_encode(classifier_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        json: data,
        accept_json: true
      )
      response
    end
    #########################
    # Manage classifiers
    #########################

    ##
    # @!method create_classifier(metadata:, training_data:)
    # Create classifier.
    # Sends data to create and train a classifier and returns information about the new
    #   classifier.
    # @param metadata [File] Metadata in JSON format. The metadata identifies the language of the data, and an
    #   optional name to identify the classifier. Specify the language with the 2-letter
    #   primary language code as assigned in ISO standard 639.
    #
    #   Supported languages are English (`en`), Arabic (`ar`), French (`fr`), German,
    #   (`de`), Italian (`it`), Japanese (`ja`), Korean (`ko`), Brazilian Portuguese
    #   (`pt`), and Spanish (`es`).
    # @param training_data [File] Training data in CSV format. Each text value must have at least one class. The
    #   data can include up to 3,000 classes and 20,000 records. For details, see [Data
    #   preparation](https://cloud.ibm.com/docs/services/natural-language-classifier?topic=natural-language-classifier-using-your-data).
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_classifier(metadata:, training_data:)
      raise ArgumentError.new("metadata must be provided") if metadata.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural_language_classifier", "V1", "create_classifier")
      headers.merge!(sdk_headers)

      form_data = {}

      unless metadata.instance_of?(StringIO) || metadata.instance_of?(File)
        metadata = metadata.respond_to?(:to_json) ? StringIO.new(metadata.to_json) : StringIO.new(metadata)
      end
      form_data[:training_metadata] = HTTP::FormData::File.new(metadata, content_type: "application/json", filename: metadata.respond_to?(:path) ? metadata.path : nil)

      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      form_data[:training_data] = HTTP::FormData::File.new(training_data, content_type: "text/csv", filename: training_data.respond_to?(:path) ? training_data.path : nil)

      method_url = "/v1/classifiers"

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        form: form_data,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_classifiers
    # List classifiers.
    # Returns an empty array if no classifiers are available.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_classifiers
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural_language_classifier", "V1", "list_classifiers")
      headers.merge!(sdk_headers)

      method_url = "/v1/classifiers"

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method get_classifier(classifier_id:)
    # Get information about a classifier.
    # Returns status and other information about a classifier.
    # @param classifier_id [String] Classifier ID to query.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_classifier(classifier_id:)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural_language_classifier", "V1", "get_classifier")
      headers.merge!(sdk_headers)

      method_url = "/v1/classifiers/%s" % [ERB::Util.url_encode(classifier_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      response
    end

    ##
    # @!method delete_classifier(classifier_id:)
    # Delete classifier.
    # @param classifier_id [String] Classifier ID to delete.
    # @return [nil]
    def delete_classifier(classifier_id:)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural_language_classifier", "V1", "delete_classifier")
      headers.merge!(sdk_headers)

      method_url = "/v1/classifiers/%s" % [ERB::Util.url_encode(classifier_id)]

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        accept_json: true
      )
      nil
    end
  end
end
