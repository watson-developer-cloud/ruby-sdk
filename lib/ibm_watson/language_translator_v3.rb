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

# IBM Watson&trade; Language Translator translates text from one language to another.
# The service offers multiple IBM provided translation models that you can customize based
# on your unique terminology and language. Use Language Translator to take news from
# across the globe and present it in your language, communicate with your customers in
# their own language, and more.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Language Translator V3 service.
  class LanguageTranslatorV3 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Language Translator service.
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
    #   "https://gateway.watsonplatform.net/language-translator/api").
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
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/language-translator/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "language_translator"
      super
      @version = args[:version]
      args[:display_name] = "Language Translator"
    end

    #########################
    # Translation
    #########################

    ##
    # @!method translate(text:, model_id: nil, source: nil, target: nil)
    # Translate.
    # Translates the input text from the source language to the target language.
    # @param text [Array[String]] Input text in UTF-8 encoding. Multiple entries will result in multiple
    #   translations in the response.
    # @param model_id [String] A globally unique string that identifies the underlying model that is used for
    #   translation.
    # @param source [String] Translation source language code.
    # @param target [String] Translation target language code.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def translate(text:, model_id: nil, source: nil, target: nil)
      raise ArgumentError.new("text must be provided") if text.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "translate")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "text" => text,
        "model_id" => model_id,
        "source" => source,
        "target" => target
      }

      method_url = "/v3/translate"

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
    # Identification
    #########################

    ##
    # @!method identify(text:)
    # Identify language.
    # Identifies the language of the input text.
    # @param text [String] Input text in UTF-8 format.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def identify(text:)
      raise ArgumentError.new("text must be provided") if text.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "identify")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = text
      headers["Content-Type"] = "text/plain"

      method_url = "/v3/identify"

      response = request(
        method: "POST",
        url: method_url,
        headers: headers,
        params: params,
        data: data,
        accept_json: true
      )
      response
    end

    ##
    # @!method list_identifiable_languages
    # List identifiable languages.
    # Lists the languages that the service can identify. Returns the language code (for
    #   example, `en` for English or `es` for Spanish) and name of each language.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_identifiable_languages
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "list_identifiable_languages")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/identifiable_languages"

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
    # Models
    #########################

    ##
    # @!method create_model(base_model_id:, forced_glossary: nil, parallel_corpus: nil, name: nil)
    # Create model.
    # Uploads Translation Memory eXchange (TMX) files to customize a translation model.
    #
    #   You can either customize a model with a forced glossary or with a corpus that
    #   contains parallel sentences. To create a model that is customized with a parallel
    #   corpus <b>and</b> a forced glossary, proceed in two steps: customize with a
    #   parallel corpus first and then customize the resulting model with a glossary.
    #   Depending on the type of customization and the size of the uploaded corpora,
    #   training can range from minutes for a glossary to several hours for a large
    #   parallel corpus. You can upload a single forced glossary file and this file must
    #   be less than <b>10 MB</b>. You can upload multiple parallel corpora tmx files. The
    #   cumulative file size of all uploaded files is limited to <b>250 MB</b>. To
    #   successfully train with a parallel corpus you must have at least <b>5,000 parallel
    #   sentences</b> in your corpus.
    #
    #   You can have a <b>maxium of 10 custom models per language pair</b>.
    # @param base_model_id [String] The model ID of the model to use as the base for customization. To see available
    #   models, use the `List models` method. Usually all IBM provided models are
    #   customizable. In addition, all your models that have been created via parallel
    #   corpus customization, can be further customized with a forced glossary.
    # @param forced_glossary [File] A TMX file with your customizations. The customizations in the file completely
    #   overwrite the domain translaton data, including high frequency or high confidence
    #   phrase translations. You can upload only one glossary with a file size less than
    #   10 MB per call. A forced glossary should contain single words or short phrases.
    # @param parallel_corpus [File] A TMX file with parallel sentences for source and target language. You can upload
    #   multiple parallel_corpus files in one request. All uploaded parallel_corpus files
    #   combined, your parallel corpus must contain at least 5,000 parallel sentences to
    #   train successfully.
    # @param name [String] An optional model name that you can use to identify the model. Valid characters
    #   are letters, numbers, dashes, underscores, spaces and apostrophes. The maximum
    #   length is 32 characters.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_model(base_model_id:, forced_glossary: nil, parallel_corpus: nil, name: nil)
      raise ArgumentError.new("base_model_id must be provided") if base_model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "create_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "base_model_id" => base_model_id,
        "name" => name
      }

      form_data = {}

      unless forced_glossary.nil?
        unless forced_glossary.instance_of?(StringIO) || forced_glossary.instance_of?(File)
          forced_glossary = forced_glossary.respond_to?(:to_json) ? StringIO.new(forced_glossary.to_json) : StringIO.new(forced_glossary)
        end
        form_data[:forced_glossary] = HTTP::FormData::File.new(forced_glossary, content_type: "application/octet-stream", filename: forced_glossary.respond_to?(:path) ? forced_glossary.path : nil)
      end

      unless parallel_corpus.nil?
        unless parallel_corpus.instance_of?(StringIO) || parallel_corpus.instance_of?(File)
          parallel_corpus = parallel_corpus.respond_to?(:to_json) ? StringIO.new(parallel_corpus.to_json) : StringIO.new(parallel_corpus)
        end
        form_data[:parallel_corpus] = HTTP::FormData::File.new(parallel_corpus, content_type: "application/octet-stream", filename: parallel_corpus.respond_to?(:path) ? parallel_corpus.path : nil)
      end

      method_url = "/v3/models"

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
    # @!method delete_model(model_id:)
    # Delete model.
    # Deletes a custom translation model.
    # @param model_id [String] Model ID of the model to delete.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def delete_model(model_id:)
      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "delete_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/models/%s" % [ERB::Util.url_encode(model_id)]

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
    # @!method get_model(model_id:)
    # Get model details.
    # Gets information about a translation model, including training status for custom
    #   models. Use this API call to poll the status of your customization request. A
    #   successfully completed training will have a status of `available`.
    # @param model_id [String] Model ID of the model to get.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_model(model_id:)
      raise ArgumentError.new("model_id must be provided") if model_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "get_model")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/models/%s" % [ERB::Util.url_encode(model_id)]

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
    # @!method list_models(source: nil, target: nil, default_models: nil)
    # List models.
    # Lists available translation models.
    # @param source [String] Specify a language code to filter results by source language.
    # @param target [String] Specify a language code to filter results by target language.
    # @param default_models [Boolean] If the default parameter isn't specified, the service will return all models
    #   (default and non-default) for each language pair. To return only default models,
    #   set this to `true`. To return only non-default models, set this to `false`. There
    #   is exactly one default model per language pair, the IBM provided base model.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_models(source: nil, target: nil, default_models: nil)
      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "list_models")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "source" => source,
        "target" => target,
        "default" => default_models
      }

      method_url = "/v3/models"

      response = request(
        method: "GET",
        url: method_url,
        headers: headers,
        params: params,
        accept_json: true
      )
      response
    end
  end
end
