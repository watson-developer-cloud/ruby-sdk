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

# The IBM Watson&trade; Visual Recognition service uses deep learning algorithms to
# identify scenes, objects, and faces  in images you upload to the service. You can create
# and train a custom classifier to identify subjects that suit your needs.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Visual Recognition V3 service.
  class VisualRecognitionV3 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Visual Recognition service.
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
    #   "https://gateway.watsonplatform.net/visual-recognition/api").
    #   The base url may differ between IBM Cloud regions.
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
      defaults[:url] = "https://gateway.watsonplatform.net/visual-recognition/api"
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      defaults[:iam_client_id] = nil
      defaults[:iam_client_secret] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "watson_vision_combined"
      super
      @version = args[:version]
      args[:display_name] = "Visual Recognition"
    end

    #########################
    # General
    #########################

    ##
    # @!method classify(images_file: nil, images_filename: nil, images_file_content_type: nil, url: nil, threshold: nil, owners: nil, classifier_ids: nil, accept_language: nil)
    # Classify images.
    # Classify images with built-in or custom classifiers.
    # @param images_file [File] An image file (.gif, .jpg, .png, .tif) or .zip file with images. Maximum image
    #   size is 10 MB. Include no more than 20 images and limit the .zip file to 100 MB.
    #   Encode the image and .zip file names in UTF-8 if they contain non-ASCII
    #   characters. The service assumes UTF-8 encoding if it encounters non-ASCII
    #   characters.
    #
    #   You can also include an image with the **url** parameter.
    # @param images_filename [String] The filename for images_file.
    # @param images_file_content_type [String] The content type of images_file.
    # @param url [String] The URL of an image (.gif, .jpg, .png, .tif) to analyze. The minimum recommended
    #   pixel density is 32X32 pixels, but the service tends to perform better with images
    #   that are at least 224 x 224 pixels. The maximum image size is 10 MB.
    #
    #   You can also include images with the **images_file** parameter.
    # @param threshold [Float] The minimum score a class must have to be displayed in the response. Set the
    #   threshold to `0.0` to return all identified classes.
    # @param owners [Array[String]] The categories of classifiers to apply. The **classifier_ids** parameter overrides
    #   **owners**, so make sure that **classifier_ids** is empty.
    #   - Use `IBM` to classify against the `default` general classifier. You get the same
    #   result if both **classifier_ids** and **owners** parameters are empty.
    #   - Use `me` to classify against all your custom classifiers. However, for better
    #   performance use **classifier_ids** to specify the specific custom classifiers to
    #   apply.
    #   - Use both `IBM` and `me` to analyze the image against both classifier categories.
    # @param classifier_ids [Array[String]] Which classifiers to apply. Overrides the **owners** parameter. You can specify
    #   both custom and built-in classifier IDs. The built-in `default` classifier is used
    #   if both **classifier_ids** and **owners** parameters are empty.
    #
    #   The following built-in classifier IDs require no training:
    #   - `default`: Returns classes from thousands of general tags.
    #   - `food`: Enhances specificity and accuracy for images of food items.
    #   - `explicit`: Evaluates whether the image might be pornographic.
    # @param accept_language [String] The desired language of parts of the response. See the response for details.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def classify(images_file: nil, images_filename: nil, images_file_content_type: nil, url: nil, threshold: nil, owners: nil, classifier_ids: nil, accept_language: nil)
      headers = {
        "Accept-Language" => accept_language
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "classify")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless images_file.nil?
        unless images_file.instance_of?(StringIO) || images_file.instance_of?(File)
          images_file = images_file.respond_to?(:to_json) ? StringIO.new(images_file.to_json) : StringIO.new(images_file)
        end
        images_filename = images_file.path if images_filename.nil? && images_file.respond_to?(:path)
        form_data[:images_file] = HTTP::FormData::File.new(images_file, content_type: images_file_content_type.nil? ? "application/octet-stream" : images_file_content_type, filename: images_filename)
      end

      classifier_ids *= "," unless classifier_ids.nil?
      owners *= "," unless owners.nil?

      form_data[:url] = HTTP::FormData::Part.new(url.to_s, content_type: "text/plain") unless url.nil?

      form_data[:threshold] = HTTP::FormData::Part.new(threshold.to_s, content_type: "application/json") unless threshold.nil?

      form_data[:owners] = HTTP::FormData::Part.new(owners, content_type: "application/json") unless owners.nil?

      form_data[:classifier_ids] = HTTP::FormData::Part.new(classifier_ids, content_type: "application/json") unless classifier_ids.nil?

      method_url = "/v3/classify"

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
    # Face
    #########################

    ##
    # @!method detect_faces(images_file: nil, images_filename: nil, images_file_content_type: nil, url: nil, accept_language: nil)
    # Detect faces in images.
    # **Important:** On April 2, 2018, the identity information in the response to calls
    #   to the Face model was removed. The identity information refers to the `name` of
    #   the person, `score`, and `type_hierarchy` knowledge graph. For details about the
    #   enhanced Face model, see the [Release
    #   notes](https://cloud.ibm.com/docs/services/visual-recognition?topic=visual-recognition-release-notes#2april2018).
    #
    #   Analyze and get data about faces in images. Responses can include estimated age
    #   and gender. This feature uses a built-in model, so no training is necessary. The
    #   **Detect faces** method does not support general biometric facial recognition.
    #
    #   Supported image formats include .gif, .jpg, .png, and .tif. The maximum image size
    #   is 10 MB. The minimum recommended pixel density is 32X32 pixels, but the service
    #   tends to perform better with images that are at least 224 x 224 pixels.
    # @param images_file [File] An image file (gif, .jpg, .png, .tif.) or .zip file with images. Limit the .zip
    #   file to 100 MB. You can include a maximum of 15 images in a request.
    #
    #   Encode the image and .zip file names in UTF-8 if they contain non-ASCII
    #   characters. The service assumes UTF-8 encoding if it encounters non-ASCII
    #   characters.
    #
    #   You can also include an image with the **url** parameter.
    # @param images_filename [String] The filename for images_file.
    # @param images_file_content_type [String] The content type of images_file.
    # @param url [String] The URL of an image to analyze. Must be in .gif, .jpg, .png, or .tif format. The
    #   minimum recommended pixel density is 32X32 pixels, but the service tends to
    #   perform better with images that are at least 224 x 224 pixels. The maximum image
    #   size is 10 MB. Redirects are followed, so you can use a shortened URL.
    #
    #   You can also include images with the **images_file** parameter.
    # @param accept_language [String] The desired language of parts of the response. See the response for details.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def detect_faces(images_file: nil, images_filename: nil, images_file_content_type: nil, url: nil, accept_language: nil)
      headers = {
        "Accept-Language" => accept_language
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "detect_faces")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless images_file.nil?
        unless images_file.instance_of?(StringIO) || images_file.instance_of?(File)
          images_file = images_file.respond_to?(:to_json) ? StringIO.new(images_file.to_json) : StringIO.new(images_file)
        end
        images_filename = images_file.path if images_filename.nil? && images_file.respond_to?(:path)
        form_data[:images_file] = HTTP::FormData::File.new(images_file, content_type: images_file_content_type.nil? ? "application/octet-stream" : images_file_content_type, filename: images_filename)
      end

      form_data[:url] = HTTP::FormData::Part.new(url.to_s, content_type: "text/plain") unless url.nil?

      method_url = "/v3/detect_faces"

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
    # Custom
    #########################

    ##
    # @!method create_classifier(name:, positive_examples:, negative_examples: nil, negative_examples_filename: nil)
    # Create a classifier.
    # Train a new multi-faceted classifier on the uploaded image data. Create your
    #   custom classifier with positive or negative examples. Include at least two sets of
    #   examples, either two positive example files or one positive and one negative file.
    #   You can upload a maximum of 256 MB per call.
    #
    #   Encode all names in UTF-8 if they contain non-ASCII characters (.zip and image
    #   file names, and classifier and class names). The service assumes UTF-8 encoding if
    #   it encounters non-ASCII characters.
    # @param name [String] The name of the new classifier. Encode special characters in UTF-8.
    # @param positive_examples [File] A .zip file of images that depict the visual subject of a class in the new
    #   classifier. You can include more than one positive example file in a call.
    #
    #   Specify the parameter name by appending `_positive_examples` to the class name.
    #   For example, `goldenretriever_positive_examples` creates the class
    #   **goldenretriever**.
    #
    #   Include at least 10 images in .jpg or .png format. The minimum recommended image
    #   resolution is 32X32 pixels. The maximum number of images is 10,000 images or 100
    #   MB per .zip file.
    #
    #   Encode special characters in the file name in UTF-8.
    # @param negative_examples [File] A .zip file of images that do not depict the visual subject of any of the classes
    #   of the new classifier. Must contain a minimum of 10 images.
    #
    #   Encode special characters in the file name in UTF-8.
    # @param negative_examples_filename [String] The filename for negative_examples.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_classifier(name:, positive_examples:, negative_examples: nil, negative_examples_filename: nil)
      raise ArgumentError.new("name must be provided") if name.nil?

      raise ArgumentError.new("positive_examples must be a hash") unless positive_examples.is_a?(Hash)
      raise ArgumentError.new("positive_examples must have at least one hash entry") if positive_examples.empty?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "create_classifier")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:name] = HTTP::FormData::Part.new(name.to_s, content_type: "text/plain")

      positive_examples&.each do |key, value|
        part_name = "%s_positive_examples" % key.to_s
        unless value.instance_of?(StringIO) || value.instance_of?(File)
          value = value.respond_to?(:to_json) ? StringIO.new(value.to_json) : StringIO.new(value)
        end
        filename = value.path if value.respond_to?(:path)
        form_data[part_name.to_sym] = HTTP::FormData::File.new(value, content_type: "application/octet-stream", filename: filename)
      end

      unless negative_examples.nil?
        unless negative_examples.instance_of?(StringIO) || negative_examples.instance_of?(File)
          negative_examples = negative_examples.respond_to?(:to_json) ? StringIO.new(negative_examples.to_json) : StringIO.new(negative_examples)
        end
        negative_examples_filename = negative_examples.path if negative_examples_filename.nil? && negative_examples.respond_to?(:path)
        form_data[:negative_examples] = HTTP::FormData::File.new(negative_examples, content_type: "application/octet-stream", filename: negative_examples_filename)
      end

      method_url = "/v3/classifiers"

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
    # @!method list_classifiers(verbose: nil)
    # Retrieve a list of classifiers.
    # @param verbose [Boolean] Specify `true` to return details about the classifiers. Omit this parameter to
    #   return a brief list of classifiers.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_classifiers(verbose: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "list_classifiers")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "verbose" => verbose
      }

      method_url = "/v3/classifiers"

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
    # @!method get_classifier(classifier_id:)
    # Retrieve classifier details.
    # Retrieve information about a custom classifier.
    # @param classifier_id [String] The ID of the classifier.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_classifier(classifier_id:)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "get_classifier")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/classifiers/%s" % [ERB::Util.url_encode(classifier_id)]

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
    # @!method update_classifier(classifier_id:, positive_examples: nil, negative_examples: nil, negative_examples_filename: nil)
    # Update a classifier.
    # Update a custom classifier by adding new positive or negative classes or by adding
    #   new images to existing classes. You must supply at least one set of positive or
    #   negative examples. For details, see [Updating custom
    #   classifiers](https://cloud.ibm.com/docs/services/visual-recognition?topic=visual-recognition-customizing#updating-custom-classifiers).
    #
    #   Encode all names in UTF-8 if they contain non-ASCII characters (.zip and image
    #   file names, and classifier and class names). The service assumes UTF-8 encoding if
    #   it encounters non-ASCII characters.
    #
    #   **Tip:** Don't make retraining calls on a classifier until the status is ready.
    #   When you submit retraining requests in parallel, the last request overwrites the
    #   previous requests. The retrained property shows the last time the classifier
    #   retraining finished.
    # @param classifier_id [String] The ID of the classifier.
    # @param positive_examples [File] A .zip file of images that depict the visual subject of a class in the classifier.
    #   The positive examples create or update classes in the classifier. You can include
    #   more than one positive example file in a call.
    #
    #   Specify the parameter name by appending `_positive_examples` to the class name.
    #   For example, `goldenretriever_positive_examples` creates the class
    #   `goldenretriever`.
    #
    #   Include at least 10 images in .jpg or .png format. The minimum recommended image
    #   resolution is 32X32 pixels. The maximum number of images is 10,000 images or 100
    #   MB per .zip file.
    #
    #   Encode special characters in the file name in UTF-8.
    # @param negative_examples [File] A .zip file of images that do not depict the visual subject of any of the classes
    #   of the new classifier. Must contain a minimum of 10 images.
    #
    #   Encode special characters in the file name in UTF-8.
    # @param negative_examples_filename [String] The filename for negative_examples.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_classifier(classifier_id:, positive_examples: nil, negative_examples: nil, negative_examples_filename: nil)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      raise ArgumentError.new("positive_examples must be a hash") unless positive_examples.nil? || positive_examples.is_a?(Hash)

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "update_classifier")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      positive_examples&.each do |key, value|
        part_name = "%s_positive_examples" % key.to_s
        unless value.instance_of?(StringIO) || value.instance_of?(File)
          value = value.respond_to?(:to_json) ? StringIO.new(value.to_json) : StringIO.new(value)
        end
        filename = value.path if value.respond_to?(:path)
        form_data[part_name.to_sym] = HTTP::FormData::File.new(value, content_type: "application/octet-stream", filename: filename)
      end

      unless negative_examples.nil?
        unless negative_examples.instance_of?(StringIO) || negative_examples.instance_of?(File)
          negative_examples = negative_examples.respond_to?(:to_json) ? StringIO.new(negative_examples.to_json) : StringIO.new(negative_examples)
        end
        negative_examples_filename = negative_examples.path if negative_examples_filename.nil? && negative_examples.respond_to?(:path)
        form_data[:negative_examples] = HTTP::FormData::File.new(negative_examples, content_type: "application/octet-stream", filename: negative_examples_filename)
      end

      method_url = "/v3/classifiers/%s" % [ERB::Util.url_encode(classifier_id)]

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
    # @!method delete_classifier(classifier_id:)
    # Delete a classifier.
    # @param classifier_id [String] The ID of the classifier.
    # @return [nil]
    def delete_classifier(classifier_id:)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "delete_classifier")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/classifiers/%s" % [ERB::Util.url_encode(classifier_id)]

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
    # Core ML
    #########################

    ##
    # @!method get_core_ml_model(classifier_id:)
    # Retrieve a Core ML model of a classifier.
    # Download a Core ML model file (.mlmodel) of a custom classifier that returns
    #   <tt>\"core_ml_enabled\": true</tt> in the classifier details.
    # @param classifier_id [String] The ID of the classifier.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_core_ml_model(classifier_id:)
      raise ArgumentError.new("classifier_id must be provided") if classifier_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "get_core_ml_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/classifiers/%s/core_ml_model" % [ERB::Util.url_encode(classifier_id)]

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: false
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
    #   You associate a customer ID with data by passing the `X-Watson-Metadata` header
    #   with a request that passes data. For more information about personal data and
    #   customer IDs, see [Information
    #   security](https://cloud.ibm.com/docs/services/visual-recognition?topic=visual-recognition-information-security).
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError.new("customer_id must be provided") if customer_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V3", "delete_user_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "customer_id" => customer_id
      }

      method_url = "/v3/user_data"

      request(
        method: "DELETE",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      nil
    end
  end
end
