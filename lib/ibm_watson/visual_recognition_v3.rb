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
require_relative "./detailed_response"

require_relative "./watson_service"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Visual Recognition V3 service.
  class VisualRecognitionV3
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
    #   The base url may differ between Bluemix regions.
    # @option args api_key [String] The API Key used to authenticate.
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
      super()
      defaults = {}
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/visual-recognition/api"
      defaults[:api_key] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      @watson_service = WatsonService.new(
        vcap_services_name: "watson_vision_combined",
        url: args[:url],
        api_key: args[:api_key],
        iam_apikey: args[:iam_apikey],
        iam_access_token: args[:iam_access_token],
        iam_url: args[:iam_url],
        use_vcap_services: true
      )
      @version = args[:version]
    end

    # :nocov:
    def add_default_headers(headers: {})
      @watson_service.add_default_headers(headers: headers)
    end

    def _iam_access_token(iam_access_token:)
      @watson_service._iam_access_token(iam_access_token: iam_access_token)
    end

    def _iam_apikey(iam_apikey:)
      @watson_service._iam_apikey(iam_apikey: iam_apikey)
    end

    # @return [DetailedResponse]
    def request(args)
      @watson_service.request(args)
    end

    # @note Chainable
    # @param headers [Hash] Custom headers to be sent with the request
    # @return [self]
    def headers(headers)
      @watson_service.headers(headers)
      self
    end

    def password=(password)
      @watson_service.password = password
    end

    def password
      @watson_service.password
    end

    def username=(username)
      @watson_service.username = username
    end

    def username
      @watson_service.username
    end

    def url=(url)
      @watson_service.url = url
    end

    def url
      @watson_service.url
    end

    # @!method configure_http_client(proxy: {}, timeout: {})
    # Sets the http client config, currently works with timeout and proxies
    # @param proxy [Hash] The hash of proxy configurations
    # @option proxy address [String] The address of the proxy
    # @option proxy port [Integer] The port of the proxy
    # @option proxy username [String] The username of the proxy, if authentication is needed
    # @option proxy password [String] The password of the proxy, if authentication is needed
    # @option proxy headers [Hash] The headers to be used with the proxy
    # @param timeout [Hash] The hash for configuring timeouts. `per_operation` has priority over `global`
    # @option timeout per_operation [Hash] Timeouts per operation. Requires `read`, `write`, `connect`
    # @option timeout global [Integer] Upper bound on total request time
    def configure_http_client(proxy: {}, timeout: {})
      @watson_service.configure_http_client(proxy: proxy, timeout: timeout)
    end
    # :nocov:
    #########################
    # General
    #########################

    ##
    # @!method classify(images_file: nil, accept_language: nil, url: nil, threshold: nil, owners: nil, classifier_ids: nil, images_file_content_type: nil, images_filename: nil)
    # Classify images.
    # Classify images with built-in or custom classifiers.
    # @param images_file [File] An image file (.jpg, .png) or .zip file with images. Maximum image size is 10 MB.
    #   Include no more than 20 images and limit the .zip file to 100 MB. Encode the image
    #   and .zip file names in UTF-8 if they contain non-ASCII characters. The service
    #   assumes UTF-8 encoding if it encounters non-ASCII characters.
    #
    #   You can also include an image with the **url** parameter.
    # @param accept_language [String] The language of the output class names. The full set of languages is supported for
    #   the built-in classifier IDs: `default`, `food`, and `explicit`. The class names of
    #   custom classifiers are not translated.
    #
    #   The response might not be in the specified language when the requested language is
    #   not supported or when there is no translation for the class name.
    # @param url [String] The URL of an image to analyze. Must be in .jpg, or .png format. The minimum
    #   recommended pixel density is 32X32 pixels per inch, and the maximum image size is
    #   10 MB.
    #
    #   You can also include images with the **images_file** parameter.
    # @param threshold [Float] The minimum score a class must have to be displayed in the response. Set the
    #   threshold to `0.0` to ignore the classification score and return all values.
    # @param owners [Array[String]] The categories of classifiers to apply. Use `IBM` to classify against the
    #   `default` general classifier, and use `me` to classify against your custom
    #   classifiers. To analyze the image against both classifier categories, set the
    #   value to both `IBM` and `me`.
    #
    #   The built-in `default` classifier is used if both **classifier_ids** and
    #   **owners** parameters are empty.
    #
    #   The **classifier_ids** parameter overrides **owners**, so make sure that
    #   **classifier_ids** is empty.
    # @param classifier_ids [Array[String]] Which classifiers to apply. Overrides the **owners** parameter. You can specify
    #   both custom and built-in classifier IDs. The built-in `default` classifier is used
    #   if both **classifier_ids** and **owners** parameters are empty.
    #
    #   The following built-in classifier IDs require no training:
    #   - `default`: Returns classes from thousands of general tags.
    #   - `food`: Enhances specificity and accuracy for images of food items.
    #   - `explicit`: Evaluates whether the image might be pornographic.
    # @param images_file_content_type [String] The content type of images_file.
    # @param images_filename [String] The filename for images_file.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def classify(images_file: nil, accept_language: nil, url: nil, threshold: nil, owners: nil, classifier_ids: nil, images_file_content_type: nil, images_filename: nil)
      headers = {
        "Accept-Language" => accept_language
      }
      params = {
        "version" => @version
      }
      unless images_file.nil?
        mime_type = images_file_content_type.nil? ? "application/octet-stream" : images_file_content_type
        unless images_file.instance_of?(StringIO) || images_file.instance_of?(File)
          images_file = images_file.respond_to?(:to_json) ? StringIO.new(images_file.to_json) : StringIO.new(images_file)
        end
        if images_filename
          images_file = images_file.instance_of?(StringIO) ? HTTP::FormData::File.new(images_file, content_type: mime_type, filename: images_filename) : HTTP::FormData::File.new(images_file.path, content_type: mime_type, filename: images_filename)
        else
          images_file = images_file.instance_of?(StringIO) ? HTTP::FormData::File.new(images_file, content_type: mime_type) : HTTP::FormData::File.new(images_file.path, content_type: mime_type)
        end
      end
      threshold = HTTP::FormData::Part.new(threshold, content_type: "text/plain") unless threshold.nil?
      owners = HTTP::FormData::Part.new(owners, content_type: "text/plain") unless owners.nil?
      classifier_ids = HTTP::FormData::Part.new(classifier_ids, content_type: "text/plain") unless classifier_ids.nil?
      method_url = "/v3/classify"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: {
          images_file: images_file,
          url: url,
          threshold: threshold,
          owners: owners,
          classifier_ids: classifier_ids
        },
        accept_json: true
      )
      response
    end
    #########################
    # Face
    #########################

    ##
    # @!method detect_faces(images_file: nil, url: nil, images_file_content_type: nil, images_filename: nil)
    # Detect faces in images.
    # **Important:** On April 2, 2018, the identity information in the response to calls
    #   to the Face model was removed. The identity information refers to the `name` of
    #   the person, `score`, and `type_hierarchy` knowledge graph. For details about the
    #   enhanced Face model, see the [Release
    #   notes](https://console.bluemix.net/docs/services/visual-recognition/release-notes.html#2april2018).
    #
    #   Analyze and get data about faces in images. Responses can include estimated age
    #   and gender. This feature uses a built-in model, so no training is necessary. The
    #   Detect faces method does not support general biometric facial recognition.
    #
    #   Supported image formats include .gif, .jpg, .png, and .tif. The maximum image size
    #   is 10 MB. The minimum recommended pixel density is 32X32 pixels per inch.
    # @param images_file [File] An image file (gif, .jpg, .png, .tif.) or .zip file with images. Limit the .zip
    #   file to 100 MB. You can include a maximum of 15 images in a request.
    #
    #   Encode the image and .zip file names in UTF-8 if they contain non-ASCII
    #   characters. The service assumes UTF-8 encoding if it encounters non-ASCII
    #   characters.
    #
    #   You can also include an image with the **url** parameter.
    # @param url [String] The URL of an image to analyze. Must be in .gif, .jpg, .png, or .tif format. The
    #   minimum recommended pixel density is 32X32 pixels per inch, and the maximum image
    #   size is 10 MB. Redirects are followed, so you can use a shortened URL.
    #
    #   You can also include images with the **images_file** parameter.
    # @param images_file_content_type [String] The content type of images_file.
    # @param images_filename [String] The filename for images_file.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def detect_faces(images_file: nil, url: nil, images_file_content_type: nil, images_filename: nil)
      headers = {
      }
      params = {
        "version" => @version
      }
      unless images_file.nil?
        mime_type = images_file_content_type.nil? ? "application/octet-stream" : images_file_content_type
        unless images_file.instance_of?(StringIO) || images_file.instance_of?(File)
          images_file = images_file.respond_to?(:to_json) ? StringIO.new(images_file.to_json) : StringIO.new(images_file)
        end
        if images_filename
          images_file = images_file.instance_of?(StringIO) ? HTTP::FormData::File.new(images_file, content_type: mime_type, filename: images_filename) : HTTP::FormData::File.new(images_file.path, content_type: mime_type, filename: images_filename)
        else
          images_file = images_file.instance_of?(StringIO) ? HTTP::FormData::File.new(images_file, content_type: mime_type) : HTTP::FormData::File.new(images_file.path, content_type: mime_type)
        end
      end
      method_url = "/v3/detect_faces"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: {
          images_file: images_file,
          url: url
        },
        accept_json: true
      )
      response
    end
    #########################
    # Custom
    #########################

    ##
    # @!method create_classifier(name:, **args)
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
    # @param args [Hash] Hash for optional parameters
    # @option args classname_positive_examples [File] A .zip file of images that depict the visual subject of a class in the new
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
    # @option args classname_positive_examples_filename [String] The filename for classname_positive_examples.
    # @option args negative_examples_filename [String] The filename for negative_examples.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_classifier(name:, **args)
      raise ArgumentError("name must be provided") if name.nil?
      raise ArgumentError("<classname>_positive_examples must be provided") unless args.keys.any? { |key| key.to_s.end_with?("_positive_examples") }
      positive_keys = args.keys
      positive_keys.keep_if { |key| key.to_s.end_with?("_positive_examples") }
      headers = {
      }
      params = {
        "version" => @version
      }
      mime_type = "application/octet-stream"
      positive_keys.each do |k|
        unless args[k].instance_of?(StringIO) || args[k].instance_of?(File)
          args[k] = args[k].respond_to?(:to_json) ? StringIO.new(args[k].to_json) : StringIO.new(args[k])
        end
        if !args[(k.to_s + "_filename").to_sym].nil?
          args[k] = args[k].instance_of?(StringIO) ? HTTP::FormData::File.new(args[k], content_type: mime_type, filename: args[(k.to_s + "_filename").to_sym]) : HTTP::FormData::File.new(args[k].path, content_type: mime_type, filename: args[(k.to_s + "_filename").to_sym])
        else
          args[k] = args[k].instance_of?(StringIO) ? HTTP::FormData::File.new(args[k], content_type: mime_type) : HTTP::FormData::File.new(args[k].path, content_type: mime_type)
        end
      end
      unless args[:negative_examples].nil?
        mime_type = "application/octet-stream"
        unless args[:negative_examples].instance_of?(StringIO) || args[:negative_examples].instance_of?(File)
          args[:negative_examples] = args[:negative_examples].respond_to?(:to_json) ? StringIO.new(args[:negative_examples].to_json) : StringIO.new(args[:negative_examples])
        end
        if args[:negative_examples_filename]
          args[:negative_examples] = args[:negative_examples].instance_of?(StringIO) ? HTTP::FormData::File.new(args[:negative_examples], content_type: mime_type, filename: args[:negative_examples_filename]) : HTTP::FormData::File.new(args[:negative_examples].path, content_type: mime_type, filename: args[:negative_examples_filename])
        else
          args[:negative_examples] = args[:negative_examples].instance_of?(StringIO) ? HTTP::FormData::File.new(args[:negative_examples], content_type: mime_type) : HTTP::FormData::File.new(args[:negative_examples].path, content_type: mime_type)
        end
      end
      form_hash = { name: name }
      positive_keys.each { |k| form_hash[k] = args[k] }
      form_hash[:negative_examples] = args[:negative_examples] unless args[:negative_examples].nil?
      method_url = "/v3/classifiers"
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_hash,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_classifiers(verbose: nil)
    # Retrieve a list of classifiers.
    # @param verbose [Boolean] Specify `true` to return details about the classifiers. Omit this parameter to
    #   return a brief list of classifiers.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def list_classifiers(verbose: nil)
      headers = {
      }
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
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_classifier(classifier_id:)
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      headers = {
      }
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
    # @!method update_classifier(classifier_id:, **args)
    # Update a classifier.
    # Update a custom classifier by adding new positive or negative classes (examples)
    #   or by adding new images to existing classes. You must supply at least one set of
    #   positive or negative examples. For details, see [Updating custom
    #   classifiers](https://console.bluemix.net/docs/services/visual-recognition/customizing.html#updating-custom-classifiers).
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
    # @option args classname_positive_examples [File] A .zip file of images that depict the visual subject of a class in the classifier.
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
    # @option args negative_examples [File] A .zip file of images that do not depict the visual subject of any of the classes
    #   of the new classifier. Must contain a minimum of 10 images.
    #
    #   Encode special characters in the file name in UTF-8.
    # @option args classname_positive_examples_filename [String] The filename for classname_positive_examples.
    # @option args negative_examples_filename [String] The filename for negative_examples.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def update_classifier(classifier_id:, **args)
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      headers = {
      }
      params = {
        "version" => @version
      }
      positive_keys = args.keys
      positive_keys.keep_if { |key| key.to_s.end_with?("_positive_examples") }
      mime_type = "application/octet-stream"
      positive_keys.each do |k|
        unless args[k].instance_of?(StringIO) || args[k].instance_of?(File)
          args[k] = args[k].respond_to?(:to_json) ? StringIO.new(args[k].to_json) : StringIO.new(args[k])
        end
        if !args[(k.to_s + "_filename").to_sym].nil?
          args[k] = args[k].instance_of?(StringIO) ? HTTP::FormData::File.new(args[k], content_type: mime_type, filename: args[(k.to_s + "_filename").to_sym]) : HTTP::FormData::File.new(args[k].path, content_type: mime_type, filename: args[(k.to_s + "_filename").to_sym])
        else
          args[k] = args[k].instance_of?(StringIO) ? HTTP::FormData::File.new(args[k], content_type: mime_type) : HTTP::FormData::File.new(args[k].path, content_type: mime_type)
        end
      end
      unless args[:negative_examples].nil?
        mime_type = "application/octet-stream"
        unless args[:negative_examples].instance_of?(StringIO) || args[:negative_examples].instance_of?(File)
          args[:negative_examples] = args[:negative_examples].respond_to?(:to_json) ? StringIO.new(args[:negative_examples].to_json) : StringIO.new(args[:negative_examples])
        end
        if args[:negative_examples_filename]
          args[:negative_examples] = args[:negative_examples].instance_of?(StringIO) ? HTTP::FormData::File.new(args[:negative_examples], content_type: mime_type, filename: args[:negative_examples_filename]) : HTTP::FormData::File.new(args[:negative_examples].path, content_type: mime_type, filename: args[:negative_examples_filename])
        else
          args[:negative_examples] = args[:negative_examples].instance_of?(StringIO) ? HTTP::FormData::File.new(args[:negative_examples], content_type: mime_type) : HTTP::FormData::File.new(args[:negative_examples].path, content_type: mime_type)
        end
      end
      form_hash = {}
      positive_keys.each { |k| form_hash[k] = args[k] }
      form_hash[:negative_examples] = args[:negative_examples] unless args[:negative_examples].nil?
      method_url = "/v3/classifiers/%s" % [ERB::Util.url_encode(classifier_id)]
      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        form: form_hash,
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
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      headers = {
      }
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
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def get_core_ml_model(classifier_id:)
      raise ArgumentError("classifier_id must be provided") if classifier_id.nil?
      headers = {
      }
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
    #   security](https://console.bluemix.net/docs/services/visual-recognition/information-security.html).
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
