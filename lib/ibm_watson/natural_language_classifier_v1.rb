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
# IBM OpenAPI SDK Code Generator Version: 3.17.0-8d569e8f-20201030-142059
#
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
    DEFAULT_SERVICE_NAME = "natural_language_classifier"
    DEFAULT_SERVICE_URL = "https://api.us-south.natural-language-classifier.watson.cloud.ibm.com"
    ##
    # @!method initialize(args)
    # Construct a new client for the Natural Language Classifier service.
    #
    # @param args [Hash] The args to initialize with
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
      user_service_url = args[:service_url] unless args[:service_url].nil?
      args = defaults.merge(args)
      args[:authenticator] = IBMCloudSdkCore::ConfigBasedAuthenticatorFactory.new.get_authenticator(service_name: args[:service_name]) if args[:authenticator].nil?
      super
      @service_url = user_service_url unless user_service_url.nil?
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
    # @!method create_classifier(training_metadata:, training_data:)
    # Create classifier.
    # Sends data to create and train a classifier and returns information about the new
    #   classifier.
    # @param training_metadata [File] Metadata in JSON format. The metadata identifies the language of the data, and an
    #   optional name to identify the classifier. Specify the language with the 2-letter
    #   primary language code as assigned in ISO standard 639.
    #
    #   Supported languages are English (`en`), Arabic (`ar`), French (`fr`), German,
    #   (`de`), Italian (`it`), Japanese (`ja`), Korean (`ko`), Brazilian Portuguese
    #   (`pt`), and Spanish (`es`).
    # @param training_data [File] Training data in CSV format. Each text value must have at least one class. The
    #   data can include up to 3,000 classes and 20,000 records. For details, see [Data
    #   preparation](https://cloud.ibm.com/docs/natural-language-classifier?topic=natural-language-classifier-using-your-data).
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_classifier(training_metadata:, training_data:)
      raise ArgumentError.new("training_metadata must be provided") if training_metadata.nil?

      raise ArgumentError.new("training_data must be provided") if training_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("natural_language_classifier", "V1", "create_classifier")
      headers.merge!(sdk_headers)

      form_data = {}

      unless training_metadata.instance_of?(StringIO) || training_metadata.instance_of?(File)
        training_metadata = training_metadata.respond_to?(:to_json) ? StringIO.new(training_metadata.to_json) : StringIO.new(training_metadata)
      end
      form_data[:training_metadata] = HTTP::FormData::File.new(training_metadata, content_type: "application/json", filename: training_metadata.respond_to?(:path) ? training_metadata.path : nil)

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
