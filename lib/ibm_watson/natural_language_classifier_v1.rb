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
require_relative "./detailed_response"

require_relative "./watson_service"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Natural Language Classifier V1 service.
  class NaturalLanguageClassifierV1 < WatsonService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Natural Language Classifier service.
    #
    # @param args [Hash] The args to initialize with
    # @option args url [String] The base url to use when contacting the service (e.g.
    #   "https://gateway.watsonplatform.net/natural-language-classifier/api").
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
    # @option args iam_apikey [String] An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # @option args iam_access_token [String] An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # @option args iam_url [String] An optional URL for the IAM service API. Defaults to
    #   'https://iam.ng.bluemix.net/identity/token'.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:url] = "https://gateway.watsonplatform.net/natural-language-classifier/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "natural_language_classifier"
      super
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
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def classify(classifier_id:, text:)
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      raise ArgumentError("text must be provided") if text.nil?
      headers = {
      }
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
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def classify_collection(classifier_id:, collection:)
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      raise ArgumentError("collection must be provided") if collection.nil?
      headers = {
      }
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
    # @!method create_classifier(metadata:, training_data:, metadata_filename: nil, training_data_filename: nil)
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
    #   data can include up to 20,000 records. For details, see [Data
    #   preparation](https://console.bluemix.net/docs/services/natural-language-classifier/using-your-data.html).
    # @param metadata_filename [String] The filename for training_metadata.
    # @param training_data_filename [String] The filename for training_data.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_classifier(metadata:, training_data:, metadata_filename: nil, training_data_filename: nil)
      raise ArgumentError("metadata must be provided") if metadata.nil?
      raise ArgumentError("training_data must be provided") if training_data.nil?
      headers = {
      }
      mime_type = "application/json"
      unless metadata.instance_of?(StringIO) || metadata.instance_of?(File)
        metadata = metadata.respond_to?(:to_json) ? StringIO.new(metadata.to_json) : StringIO.new(metadata)
      end
      if metadata_filename
        metadata = metadata.instance_of?(StringIO) ? HTTP::FormData::File.new(metadata, content_type: mime_type, filename: metadata_filename) : HTTP::FormData::File.new(metadata.path, content_type: mime_type, filename: metadata_filename)
      else
        metadata = metadata.instance_of?(StringIO) ? HTTP::FormData::File.new(metadata, content_type: mime_type) : HTTP::FormData::File.new(metadata.path, content_type: mime_type)
      end
      mime_type = "text/csv"
      unless training_data.instance_of?(StringIO) || training_data.instance_of?(File)
        training_data = training_data.respond_to?(:to_json) ? StringIO.new(training_data.to_json) : StringIO.new(training_data)
      end
      if training_data_filename
        training_data = training_data.instance_of?(StringIO) ? HTTP::FormData::File.new(training_data, content_type: mime_type, filename: training_data_filename) : HTTP::FormData::File.new(training_data.path, content_type: mime_type, filename: training_data_filename)
      else
        training_data = training_data.instance_of?(StringIO) ? HTTP::FormData::File.new(training_data, content_type: mime_type) : HTTP::FormData::File.new(training_data.path, content_type: mime_type)
      end
      method_url = "/v1/classifiers"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        form: {
          training_metadata: metadata,
          training_data: training_data
        },
        accept_json: true
      )
      response
    end

    ##
    # @!method list_classifiers
    # List classifiers.
    # Returns an empty array if no classifiers are available.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_classifiers
      headers = {
      }
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
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_classifier(classifier_id:)
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      headers = {
      }
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
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      headers = {
      }
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
