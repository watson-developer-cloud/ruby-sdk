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
# IBM OpenAPI SDK Code Generator Version: 3.19.0-be3b4618-20201113-200858
#
# IBM Watson&trade; Compare and Comply analyzes governing documents to provide details
# about critical aspects of the documents.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Compare Comply V1 service.
  class CompareComplyV1 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    DEFAULT_SERVICE_NAME = "compare_comply"
    DEFAULT_SERVICE_URL = "https://api.us-south.compare-comply.watson.cloud.ibm.com"
    attr_accessor :version
    ##
    # @!method initialize(args)
    # Construct a new client for the Compare Comply service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] Release date of the version of the API you want to use. Specify dates in
    #   YYYY-MM-DD format. The current version is `2018-10-15`.
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
    # HTML conversion
    #########################

    ##
    # @!method convert_to_html(file:, file_content_type: nil, model: nil)
    # Convert document to HTML.
    # Converts a document to HTML.
    # @param file [File] The document to convert.
    # @param file_content_type [String] The content type of file.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def convert_to_html(file:, file_content_type: nil, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("file must be provided") if file.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "convert_to_html")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "model" => model
      }

      form_data = {}

      unless file.instance_of?(StringIO) || file.instance_of?(File)
        file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
      end
      form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: file.respond_to?(:path) ? file.path : nil)

      method_url = "/v1/html_conversion"

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
    # Element classification
    #########################

    ##
    # @!method classify_elements(file:, file_content_type: nil, model: nil)
    # Classify the elements of a document.
    # Analyzes the structural and semantic elements of a document.
    # @param file [File] The document to classify.
    # @param file_content_type [String] The content type of file.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def classify_elements(file:, file_content_type: nil, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("file must be provided") if file.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "classify_elements")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "model" => model
      }

      form_data = {}

      unless file.instance_of?(StringIO) || file.instance_of?(File)
        file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
      end
      form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: file.respond_to?(:path) ? file.path : nil)

      method_url = "/v1/element_classification"

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
    # Tables
    #########################

    ##
    # @!method extract_tables(file:, file_content_type: nil, model: nil)
    # Extract a document's tables.
    # Analyzes the tables in a document.
    # @param file [File] The document on which to run table extraction.
    # @param file_content_type [String] The content type of file.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def extract_tables(file:, file_content_type: nil, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("file must be provided") if file.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "extract_tables")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "model" => model
      }

      form_data = {}

      unless file.instance_of?(StringIO) || file.instance_of?(File)
        file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
      end
      form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: file.respond_to?(:path) ? file.path : nil)

      method_url = "/v1/tables"

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
    # Comparison
    #########################

    ##
    # @!method compare_documents(file_1:, file_2:, file_1_content_type: nil, file_2_content_type: nil, file_1_label: nil, file_2_label: nil, model: nil)
    # Compare two documents.
    # Compares two input documents. Documents must be in the same format.
    # @param file_1 [File] The first document to compare.
    # @param file_2 [File] The second document to compare.
    # @param file_1_content_type [String] The content type of file_1.
    # @param file_2_content_type [String] The content type of file_2.
    # @param file_1_label [String] A text label for the first document.
    # @param file_2_label [String] A text label for the second document.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def compare_documents(file_1:, file_2:, file_1_content_type: nil, file_2_content_type: nil, file_1_label: nil, file_2_label: nil, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("file_1 must be provided") if file_1.nil?

      raise ArgumentError.new("file_2 must be provided") if file_2.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "compare_documents")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "file_1_label" => file_1_label,
        "file_2_label" => file_2_label,
        "model" => model
      }

      form_data = {}

      unless file_1.instance_of?(StringIO) || file_1.instance_of?(File)
        file_1 = file_1.respond_to?(:to_json) ? StringIO.new(file_1.to_json) : StringIO.new(file_1)
      end
      form_data[:file_1] = HTTP::FormData::File.new(file_1, content_type: file_1_content_type.nil? ? "application/octet-stream" : file_1_content_type, filename: file_1.respond_to?(:path) ? file_1.path : nil)

      unless file_2.instance_of?(StringIO) || file_2.instance_of?(File)
        file_2 = file_2.respond_to?(:to_json) ? StringIO.new(file_2.to_json) : StringIO.new(file_2)
      end
      form_data[:file_2] = HTTP::FormData::File.new(file_2, content_type: file_2_content_type.nil? ? "application/octet-stream" : file_2_content_type, filename: file_2.respond_to?(:path) ? file_2.path : nil)

      method_url = "/v1/comparison"

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
    # Feedback
    #########################

    ##
    # @!method add_feedback(feedback_data:, user_id: nil, comment: nil)
    # Add feedback.
    # Adds feedback in the form of _labels_ from a subject-matter expert (SME) to a
    #   governing document.
    #   **Important:** Feedback is not immediately incorporated into the training model,
    #   nor is it guaranteed to be incorporated at a later date. Instead, submitted
    #   feedback is used to suggest future updates to the training model.
    # @param feedback_data [FeedbackDataInput] Feedback data for submission.
    # @param user_id [String] An optional string identifying the user.
    # @param comment [String] An optional comment on or description of the feedback.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def add_feedback(feedback_data:, user_id: nil, comment: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("feedback_data must be provided") if feedback_data.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "add_feedback")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "feedback_data" => feedback_data,
        "user_id" => user_id,
        "comment" => comment
      }

      method_url = "/v1/feedback"

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
    # @!method list_feedback(feedback_type: nil, document_title: nil, model_id: nil, model_version: nil, category_removed: nil, category_added: nil, category_not_changed: nil, type_removed: nil, type_added: nil, type_not_changed: nil, page_limit: nil, cursor: nil, sort: nil, include_total: nil)
    # List the feedback in a document.
    # Lists the feedback in a document.
    # @param feedback_type [String] An optional string that filters the output to include only feedback with the
    #   specified feedback type. The only permitted value is `element_classification`.
    # @param document_title [String] An optional string that filters the output to include only feedback from the
    #   document with the specified `document_title`.
    # @param model_id [String] An optional string that filters the output to include only feedback with the
    #   specified `model_id`. The only permitted value is `contracts`.
    # @param model_version [String] An optional string that filters the output to include only feedback with the
    #   specified `model_version`.
    # @param category_removed [String] An optional string in the form of a comma-separated list of categories. If it is
    #   specified, the service filters the output to include only feedback that has at
    #   least one category from the list removed.
    # @param category_added [String] An optional string in the form of a comma-separated list of categories. If this is
    #   specified, the service filters the output to include only feedback that has at
    #   least one category from the list added.
    # @param category_not_changed [String] An optional string in the form of a comma-separated list of categories. If this is
    #   specified, the service filters the output to include only feedback that has at
    #   least one category from the list unchanged.
    # @param type_removed [String] An optional string of comma-separated `nature`:`party` pairs. If this is
    #   specified, the service filters the output to include only feedback that has at
    #   least one `nature`:`party` pair from the list removed.
    # @param type_added [String] An optional string of comma-separated `nature`:`party` pairs. If this is
    #   specified, the service filters the output to include only feedback that has at
    #   least one `nature`:`party` pair from the list removed.
    # @param type_not_changed [String] An optional string of comma-separated `nature`:`party` pairs. If this is
    #   specified, the service filters the output to include only feedback that has at
    #   least one `nature`:`party` pair from the list unchanged.
    # @param page_limit [Fixnum] An optional integer specifying the number of documents that you want the service
    #   to return.
    # @param cursor [String] An optional string that returns the set of documents after the previous set. Use
    #   this parameter with the `page_limit` parameter.
    # @param sort [String] An optional comma-separated list of fields in the document to sort on. You can
    #   optionally specify the sort direction by prefixing the value of the field with `-`
    #   for descending order or `+` for ascending order (the default). Currently permitted
    #   sorting fields are `created`, `user_id`, and `document_title`.
    # @param include_total [Boolean] An optional boolean value. If specified as `true`, the `pagination` object in the
    #   output includes a value called `total` that gives the total count of feedback
    #   created.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_feedback(feedback_type: nil, document_title: nil, model_id: nil, model_version: nil, category_removed: nil, category_added: nil, category_not_changed: nil, type_removed: nil, type_added: nil, type_not_changed: nil, page_limit: nil, cursor: nil, sort: nil, include_total: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "list_feedback")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "feedback_type" => feedback_type,
        "document_title" => document_title,
        "model_id" => model_id,
        "model_version" => model_version,
        "category_removed" => category_removed,
        "category_added" => category_added,
        "category_not_changed" => category_not_changed,
        "type_removed" => type_removed,
        "type_added" => type_added,
        "type_not_changed" => type_not_changed,
        "page_limit" => page_limit,
        "cursor" => cursor,
        "sort" => sort,
        "include_total" => include_total
      }

      method_url = "/v1/feedback"

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
    # @!method get_feedback(feedback_id:, model: nil)
    # Get a specified feedback entry.
    # Gets a feedback entry with a specified `feedback_id`.
    # @param feedback_id [String] A string that specifies the feedback entry to be included in the output.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_feedback(feedback_id:, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("feedback_id must be provided") if feedback_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "get_feedback")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "model" => model
      }

      method_url = "/v1/feedback/%s" % [ERB::Util.url_encode(feedback_id)]

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
    # @!method delete_feedback(feedback_id:, model: nil)
    # Delete a specified feedback entry.
    # Deletes a feedback entry with a specified `feedback_id`.
    # @param feedback_id [String] A string that specifies the feedback entry to be deleted from the document.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_feedback(feedback_id:, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("feedback_id must be provided") if feedback_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "delete_feedback")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "model" => model
      }

      method_url = "/v1/feedback/%s" % [ERB::Util.url_encode(feedback_id)]

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
    # Batches
    #########################

    ##
    # @!method create_batch(function:, input_credentials_file:, input_bucket_location:, input_bucket_name:, output_credentials_file:, output_bucket_location:, output_bucket_name:, model: nil)
    # Submit a batch-processing request.
    # Run Compare and Comply methods over a collection of input documents.
    #
    #   **Important:** Batch processing requires the use of the [IBM Cloud Object Storage
    #   service](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-about#about-ibm-cloud-object-storage).
    #   The use of IBM Cloud Object Storage with Compare and Comply is discussed at [Using
    #   batch
    #   processing](https://cloud.ibm.com/docs/compare-comply?topic=compare-comply-batching#before-you-batch).
    # @param function [String] The Compare and Comply method to run across the submitted input documents.
    # @param input_credentials_file [File] A JSON file containing the input Cloud Object Storage credentials. At a minimum,
    #   the credentials must enable `READ` permissions on the bucket defined by the
    #   `input_bucket_name` parameter.
    # @param input_bucket_location [String] The geographical location of the Cloud Object Storage input bucket as listed on
    #   the **Endpoint** tab of your Cloud Object Storage instance; for example, `us-geo`,
    #   `eu-geo`, or `ap-geo`.
    # @param input_bucket_name [String] The name of the Cloud Object Storage input bucket.
    # @param output_credentials_file [File] A JSON file that lists the Cloud Object Storage output credentials. At a minimum,
    #   the credentials must enable `READ` and `WRITE` permissions on the bucket defined
    #   by the `output_bucket_name` parameter.
    # @param output_bucket_location [String] The geographical location of the Cloud Object Storage output bucket as listed on
    #   the **Endpoint** tab of your Cloud Object Storage instance; for example, `us-geo`,
    #   `eu-geo`, or `ap-geo`.
    # @param output_bucket_name [String] The name of the Cloud Object Storage output bucket.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_batch(function:, input_credentials_file:, input_bucket_location:, input_bucket_name:, output_credentials_file:, output_bucket_location:, output_bucket_name:, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("function must be provided") if function.nil?

      raise ArgumentError.new("input_credentials_file must be provided") if input_credentials_file.nil?

      raise ArgumentError.new("input_bucket_location must be provided") if input_bucket_location.nil?

      raise ArgumentError.new("input_bucket_name must be provided") if input_bucket_name.nil?

      raise ArgumentError.new("output_credentials_file must be provided") if output_credentials_file.nil?

      raise ArgumentError.new("output_bucket_location must be provided") if output_bucket_location.nil?

      raise ArgumentError.new("output_bucket_name must be provided") if output_bucket_name.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "create_batch")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "function" => function,
        "model" => model
      }

      form_data = {}

      unless input_credentials_file.instance_of?(StringIO) || input_credentials_file.instance_of?(File)
        input_credentials_file = input_credentials_file.respond_to?(:to_json) ? StringIO.new(input_credentials_file.to_json) : StringIO.new(input_credentials_file)
      end
      form_data[:input_credentials_file] = HTTP::FormData::File.new(input_credentials_file, content_type: "application/json", filename: input_credentials_file.respond_to?(:path) ? input_credentials_file.path : nil)

      form_data[:input_bucket_location] = HTTP::FormData::Part.new(input_bucket_location.to_s, content_type: "text/plain")

      form_data[:input_bucket_name] = HTTP::FormData::Part.new(input_bucket_name.to_s, content_type: "text/plain")

      unless output_credentials_file.instance_of?(StringIO) || output_credentials_file.instance_of?(File)
        output_credentials_file = output_credentials_file.respond_to?(:to_json) ? StringIO.new(output_credentials_file.to_json) : StringIO.new(output_credentials_file)
      end
      form_data[:output_credentials_file] = HTTP::FormData::File.new(output_credentials_file, content_type: "application/json", filename: output_credentials_file.respond_to?(:path) ? output_credentials_file.path : nil)

      form_data[:output_bucket_location] = HTTP::FormData::Part.new(output_bucket_location.to_s, content_type: "text/plain")

      form_data[:output_bucket_name] = HTTP::FormData::Part.new(output_bucket_name.to_s, content_type: "text/plain")

      method_url = "/v1/batches"

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
    # @!method list_batches
    # List submitted batch-processing jobs.
    # Lists batch-processing jobs submitted by users.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_batches
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "list_batches")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/batches"

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
    # @!method get_batch(batch_id:)
    # Get information about a specific batch-processing job.
    # Gets information about a batch-processing job with a specified ID.
    # @param batch_id [String] The ID of the batch-processing job whose information you want to retrieve.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_batch(batch_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("batch_id must be provided") if batch_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "get_batch")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v1/batches/%s" % [ERB::Util.url_encode(batch_id)]

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
    # @!method update_batch(batch_id:, action:, model: nil)
    # Update a pending or active batch-processing job.
    # Updates a pending or active batch-processing job. You can rescan the input bucket
    #   to check for new documents or cancel a job.
    # @param batch_id [String] The ID of the batch-processing job you want to update.
    # @param action [String] The action you want to perform on the specified batch-processing job.
    # @param model [String] The analysis model to be used by the service. For the **Element classification**
    #   and **Compare two documents** methods, the default is `contracts`. For the
    #   **Extract tables** method, the default is `tables`. These defaults apply to the
    #   standalone methods as well as to the methods' use in batch-processing requests.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_batch(batch_id:, action:, model: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("batch_id must be provided") if batch_id.nil?

      raise ArgumentError.new("action must be provided") if action.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("compare-comply", "V1", "update_batch")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "action" => action,
        "model" => model
      }

      method_url = "/v1/batches/%s" % [ERB::Util.url_encode(batch_id)]

      response = request(
        method: "PUT",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
  end
end
