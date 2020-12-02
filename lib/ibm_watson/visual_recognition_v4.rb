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
# IBM OpenAPI SDK Code Generator Version: 3.19.0-be3b4618-20201113-200858
#
# Provide images to the IBM Watson&trade; Visual Recognition service for analysis. The
# service detects objects based on a set of images with training data.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Visual Recognition V4 service.
  class VisualRecognitionV4 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    DEFAULT_SERVICE_NAME = "visual_recognition"
    DEFAULT_SERVICE_URL = "https://api.us-south.visual-recognition.watson.cloud.ibm.com"
    attr_accessor :version
    ##
    # @!method initialize(args)
    # Construct a new client for the Visual Recognition service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] Release date of the API version you want to use. Specify dates in YYYY-MM-DD
    #   format. The current version is `2019-02-11`.
    # @option args service_url [String] The base service URL to use when contacting the service.
    #   The base service_url may differ between IBM Cloud regions.
    # @option args authenticator [Object] The Authenticator instance to be configured for this service.
    # @option args service_name [String] The name of the service to configure. Will be used as the key to load
    #   any external configuration, if applicable.
    def initialize(args = {})
      warn "On 1 December 2021, Visual Recognition will no longer be available. For more information, see the README."
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
    # Analysis
    #########################

    ##
    # @!method analyze(collection_ids:, features:, images_file: nil, image_url: nil, threshold: nil)
    # Analyze images.
    # Analyze images by URL, by file, or both against your own collection. Make sure
    #   that **training_status.objects.ready** is `true` for the feature before you use a
    #   collection to analyze images.
    #
    #   Encode the image and .zip file names in UTF-8 if they contain non-ASCII
    #   characters. The service assumes UTF-8 encoding if it encounters non-ASCII
    #   characters.
    # @param collection_ids [Array[String]] The IDs of the collections to analyze.
    # @param features [Array[String]] The features to analyze.
    # @param images_file [Array[FileWithMetadata]] An array of image files (.jpg or .png) or .zip files with images.
    #   - Include a maximum of 20 images in a request.
    #   - Limit the .zip file to 100 MB.
    #   - Limit each image file to 10 MB.
    #
    #   You can also include an image with the **image_url** parameter.
    # @param image_url [Array[String]] An array of URLs of image files (.jpg or .png).
    #   - Include a maximum of 20 images in a request.
    #   - Limit each image file to 10 MB.
    #   - Minimum width and height is 30 pixels, but the service tends to perform better
    #   with images that are at least 300 x 300 pixels. Maximum is 5400 pixels for either
    #   height or width.
    #
    #   You can also include images with the **images_file** parameter.
    # @param threshold [Float] The minimum score a feature must have to be returned.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def analyze(collection_ids:, features:, images_file: nil, image_url: nil, threshold: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_ids must be provided") if collection_ids.nil?

      raise ArgumentError.new("features must be provided") if features.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "analyze")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      collection_ids *= "," unless collection_ids.nil?
      features *= "," unless features.nil?

      form_data[:collection_ids] = HTTP::FormData::Part.new(collection_ids.to_s, content_type: "text/plain")

      form_data[:features] = HTTP::FormData::Part.new(features.to_s, content_type: "text/plain")

      form_data[:images_file] = []
      images_file&.each do |item|
        unless item[:data].instance_of?(StringIO) || item[:data].instance_of?(File)
          item[:data] = item[:data].respond_to?(:to_json) ? StringIO.new(item[:data].to_json) : StringIO.new(item[:data])
        end
        item[:filename] = item[:data].path if item[:filename].nil? && item[:data].respond_to?(:path)
        form_data[:images_file].push(HTTP::FormData::File.new(item[:data], content_type: item[:content_type], filename: item[:filename]))
      end

      form_data[:image_url] = []
      image_url&.each do |item|
        form_data[:image_url].push(HTTP::FormData::Part.new(item.to_s, content_type: "text/plain"))
      end

      form_data[:threshold] = HTTP::FormData::Part.new(threshold.to_s, content_type: "application/json") unless threshold.nil?

      method_url = "/v4/analyze"

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
    # @!method create_collection(name: nil, description: nil)
    # Create a collection.
    # Create a collection that can be used to store images.
    #
    #   To create a collection without specifying a name and description, include an empty
    #   JSON object in the request body.
    #
    #   Encode the name and description in UTF-8 if they contain non-ASCII characters. The
    #   service assumes UTF-8 encoding if it encounters non-ASCII characters.
    # @param name [String] The name of the collection. The name can contain alphanumeric, underscore, hyphen,
    #   and dot characters. It cannot begin with the reserved prefix `sys-`.
    # @param description [String] The description of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_collection(name: nil, description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "create_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description
      }

      method_url = "/v4/collections"

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
    # @!method list_collections
    # List collections.
    # Retrieves a list of collections for the service instance.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_collections
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "list_collections")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections"

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
    # @!method get_collection(collection_id:)
    # Get collection details.
    # Get details of one collection.
    # @param collection_id [String] The identifier of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_collection(collection_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "get_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s" % [ERB::Util.url_encode(collection_id)]

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
    # @!method update_collection(collection_id:, name: nil, description: nil)
    # Update a collection.
    # Update the name or description of a collection.
    #
    #   Encode the name and description in UTF-8 if they contain non-ASCII characters. The
    #   service assumes UTF-8 encoding if it encounters non-ASCII characters.
    # @param collection_id [String] The identifier of the collection.
    # @param name [String] The name of the collection. The name can contain alphanumeric, underscore, hyphen,
    #   and dot characters. It cannot begin with the reserved prefix `sys-`.
    # @param description [String] The description of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_collection(collection_id:, name: nil, description: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "update_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "name" => name,
        "description" => description
      }

      method_url = "/v4/collections/%s" % [ERB::Util.url_encode(collection_id)]

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
    # @!method delete_collection(collection_id:)
    # Delete a collection.
    # Delete a collection from the service instance.
    # @param collection_id [String] The identifier of the collection.
    # @return [nil]
    def delete_collection(collection_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "delete_collection")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s" % [ERB::Util.url_encode(collection_id)]

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
    # @!method get_model_file(collection_id:, feature:, model_format:)
    # Get a model.
    # Download a model that you can deploy to detect objects in images. The collection
    #   must include a generated model, which is indicated in the response for the
    #   collection details as `"rscnn_ready": true`. If the value is `false`, train or
    #   retrain the collection to generate the model.
    #
    #   Currently, the model format is specific to Android apps. For more information
    #   about how to deploy the model to your app, see the [Watson Visual Recognition on
    #   Android](https://github.com/matt-ny/rscnn) project in GitHub.
    # @param collection_id [String] The identifier of the collection.
    # @param feature [String] The feature for the model.
    # @param model_format [String] The format of the returned model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_model_file(collection_id:, feature:, model_format:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("feature must be provided") if feature.nil?

      raise ArgumentError.new("model_format must be provided") if model_format.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "get_model_file")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "feature" => feature,
        "model_format" => model_format
      }

      method_url = "/v4/collections/%s/model" % [ERB::Util.url_encode(collection_id)]

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
    # Images
    #########################

    ##
    # @!method add_images(collection_id:, images_file: nil, image_url: nil, training_data: nil)
    # Add images.
    # Add images to a collection by URL, by file, or both.
    #
    #   Encode the image and .zip file names in UTF-8 if they contain non-ASCII
    #   characters. The service assumes UTF-8 encoding if it encounters non-ASCII
    #   characters.
    # @param collection_id [String] The identifier of the collection.
    # @param images_file [Array[FileWithMetadata]] An array of image files (.jpg or .png) or .zip files with images.
    #   - Include a maximum of 20 images in a request.
    #   - Limit the .zip file to 100 MB.
    #   - Limit each image file to 10 MB.
    #
    #   You can also include an image with the **image_url** parameter.
    # @param image_url [Array[String]] The array of URLs of image files (.jpg or .png).
    #   - Include a maximum of 20 images in a request.
    #   - Limit each image file to 10 MB.
    #   - Minimum width and height is 30 pixels, but the service tends to perform better
    #   with images that are at least 300 x 300 pixels. Maximum is 5400 pixels for either
    #   height or width.
    #
    #   You can also include images with the **images_file** parameter.
    # @param training_data [String] Training data for a single image. Include training data only if you add one image
    #   with the request.
    #
    #   The `object` property can contain alphanumeric, underscore, hyphen, space, and dot
    #   characters. It cannot begin with the reserved prefix `sys-` and must be no longer
    #   than 32 characters.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def add_images(collection_id:, images_file: nil, image_url: nil, training_data: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "add_images")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      form_data[:images_file] = []
      images_file&.each do |item|
        unless item[:data].instance_of?(StringIO) || item[:data].instance_of?(File)
          item[:data] = item[:data].respond_to?(:to_json) ? StringIO.new(item[:data].to_json) : StringIO.new(item[:data])
        end
        item[:filename] = item[:data].path if item[:filename].nil? && item[:data].respond_to?(:path)
        form_data[:images_file].push(HTTP::FormData::File.new(item[:data], content_type: item[:content_type], filename: item[:filename]))
      end

      form_data[:image_url] = []
      image_url&.each do |item|
        form_data[:image_url].push(HTTP::FormData::Part.new(item.to_s, content_type: "text/plain"))
      end

      form_data[:training_data] = HTTP::FormData::Part.new(training_data.to_s, content_type: "text/plain") unless training_data.nil?

      method_url = "/v4/collections/%s/images" % [ERB::Util.url_encode(collection_id)]

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
    # @!method list_images(collection_id:)
    # List images.
    # Retrieves a list of images in a collection.
    # @param collection_id [String] The identifier of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_images(collection_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "list_images")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s/images" % [ERB::Util.url_encode(collection_id)]

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
    # @!method get_image_details(collection_id:, image_id:)
    # Get image details.
    # Get the details of an image in a collection.
    # @param collection_id [String] The identifier of the collection.
    # @param image_id [String] The identifier of the image.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_image_details(collection_id:, image_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("image_id must be provided") if image_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "get_image_details")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s/images/%s" % [ERB::Util.url_encode(collection_id), ERB::Util.url_encode(image_id)]

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
    # @!method delete_image(collection_id:, image_id:)
    # Delete an image.
    # Delete one image from a collection.
    # @param collection_id [String] The identifier of the collection.
    # @param image_id [String] The identifier of the image.
    # @return [nil]
    def delete_image(collection_id:, image_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("image_id must be provided") if image_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "delete_image")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s/images/%s" % [ERB::Util.url_encode(collection_id), ERB::Util.url_encode(image_id)]

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
    # @!method get_jpeg_image(collection_id:, image_id:, size: nil)
    # Get a JPEG file of an image.
    # Download a JPEG representation of an image.
    # @param collection_id [String] The identifier of the collection.
    # @param image_id [String] The identifier of the image.
    # @param size [String] The image size. Specify `thumbnail` to return a version that maintains the
    #   original aspect ratio but is no larger than 200 pixels in the larger dimension.
    #   For example, an original 800 x 1000 image is resized to 160 x 200 pixels.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_jpeg_image(collection_id:, image_id:, size: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("image_id must be provided") if image_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "get_jpeg_image")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "size" => size
      }

      method_url = "/v4/collections/%s/images/%s/jpeg" % [ERB::Util.url_encode(collection_id), ERB::Util.url_encode(image_id)]

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
    # Objects
    #########################

    ##
    # @!method list_object_metadata(collection_id:)
    # List object metadata.
    # Retrieves a list of object names in a collection.
    # @param collection_id [String] The identifier of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_object_metadata(collection_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "list_object_metadata")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s/objects" % [ERB::Util.url_encode(collection_id)]

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
    # @!method update_object_metadata(collection_id:, object:, new_object:)
    # Update an object name.
    # Update the name of an object. A successful request updates the training data for
    #   all images that use the object.
    # @param collection_id [String] The identifier of the collection.
    # @param object [String] The name of the object.
    # @param new_object [String] The updated name of the object. The name can contain alphanumeric, underscore,
    #   hyphen, space, and dot characters. It cannot begin with the reserved prefix
    #   `sys-`.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def update_object_metadata(collection_id:, object:, new_object:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("object must be provided") if object.nil?

      raise ArgumentError.new("new_object must be provided") if new_object.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "update_object_metadata")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "object" => new_object
      }

      method_url = "/v4/collections/%s/objects/%s" % [ERB::Util.url_encode(collection_id), ERB::Util.url_encode(object)]

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
    # @!method get_object_metadata(collection_id:, object:)
    # Get object metadata.
    # Get the number of bounding boxes for a single object in a collection.
    # @param collection_id [String] The identifier of the collection.
    # @param object [String] The name of the object.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_object_metadata(collection_id:, object:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("object must be provided") if object.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "get_object_metadata")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s/objects/%s" % [ERB::Util.url_encode(collection_id), ERB::Util.url_encode(object)]

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
    # @!method delete_object(collection_id:, object:)
    # Delete an object.
    # Delete one object from a collection. A successful request deletes the training
    #   data from all images that use the object.
    # @param collection_id [String] The identifier of the collection.
    # @param object [String] The name of the object.
    # @return [nil]
    def delete_object(collection_id:, object:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("object must be provided") if object.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "delete_object")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s/objects/%s" % [ERB::Util.url_encode(collection_id), ERB::Util.url_encode(object)]

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
    # Training
    #########################

    ##
    # @!method train(collection_id:)
    # Train a collection.
    # Start training on images in a collection. The collection must have enough training
    #   data and untrained data (the **training_status.objects.data_changed** is `true`).
    #   If training is in progress, the request queues the next training job.
    # @param collection_id [String] The identifier of the collection.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def train(collection_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "train")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v4/collections/%s/train" % [ERB::Util.url_encode(collection_id)]

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end

    ##
    # @!method add_image_training_data(collection_id:, image_id:, objects: nil)
    # Add training data to an image.
    # Add, update, or delete training data for an image. Encode the object name in UTF-8
    #   if it contains non-ASCII characters. The service assumes UTF-8 encoding if it
    #   encounters non-ASCII characters.
    #
    #   Elements in the request replace the existing elements.
    #
    #   - To update the training data, provide both the unchanged and the new or changed
    #   values.
    #
    #   - To delete the training data, provide an empty value for the training data.
    # @param collection_id [String] The identifier of the collection.
    # @param image_id [String] The identifier of the image.
    # @param objects [Array[TrainingDataObject]] Training data for specific objects.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def add_image_training_data(collection_id:, image_id:, objects: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("collection_id must be provided") if collection_id.nil?

      raise ArgumentError.new("image_id must be provided") if image_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "add_image_training_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "objects" => objects
      }

      method_url = "/v4/collections/%s/images/%s/training_data" % [ERB::Util.url_encode(collection_id), ERB::Util.url_encode(image_id)]

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
    # @!method get_training_usage(start_time: nil, end_time: nil)
    # Get training usage.
    # Information about the completed training events. You can use this information to
    #   determine how close you are to the training limits for the month.
    # @param start_time [Time] The earliest day to include training events. Specify dates in YYYY-MM-DD format.
    #   If empty or not specified, the earliest training event is included.
    # @param end_time [Time] The most recent day to include training events. Specify dates in YYYY-MM-DD
    #   format. All events for the day are included. If empty or not specified, the
    #   current day is used. Specify the same value as `start_time` to request events for
    #   a single day.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_training_usage(start_time: nil, end_time: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "get_training_usage")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "start_time" => start_time,
        "end_time" => end_time
      }

      method_url = "/v4/training_usage"

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
    #   You associate a customer ID with data by passing the `X-Watson-Metadata` header
    #   with a request that passes data. For more information about personal data and
    #   customer IDs, see [Information
    #   security](https://cloud.ibm.com/docs/visual-recognition?topic=visual-recognition-information-security).
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("customer_id must be provided") if customer_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("watson_vision_combined", "V4", "delete_user_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "customer_id" => customer_id
      }

      method_url = "/v4/user_data"

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
