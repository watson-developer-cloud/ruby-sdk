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
# IBM OpenAPI SDK Code Generator Version: 3.16.0-36b26b63-20201022-212410
#
# IBM Watson&trade; Language Translator translates text from one language to another.
# The service offers multiple IBM-provided translation models that you can customize based
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
    DEFAULT_SERVICE_NAME = "language_translator"
    DEFAULT_SERVICE_URL = "https://api.us-south.language-translator.watson.cloud.ibm.com"
    attr_accessor :version
    ##
    # @!method initialize(args)
    # Construct a new client for the Language Translator service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] Release date of the version of the API you want to use. Specify dates in
    #   YYYY-MM-DD format. The current version is `2018-05-01`.
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
    # Languages
    #########################

    ##
    # @!method list_languages
    # List supported languages.
    # Lists all supported languages for translation. The method returns an array of
    #   supported languages with information about each language. Languages are listed in
    #   alphabetical order by language code (for example, `af`, `ar`). In addition to
    #   basic information about each language, the response indicates whether the language
    #   is `supported_as_source` for translation and `supported_as_target` for
    #   translation. It also lists whether the language is `identifiable`.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_languages
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "list_languages")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/languages"

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
    # Translation
    #########################

    ##
    # @!method translate(text:, model_id: nil, source: nil, target: nil)
    # Translate.
    # Translates the input text from the source language to the target language. Specify
    #   a model ID that indicates the source and target languages, or specify the source
    #   and target languages individually. You can omit the source language to have the
    #   service attempt to detect the language from the input text. If you omit the source
    #   language, the request must contain sufficient input text for the service to
    #   identify the source language.
    #
    #   You can translate a maximum of 50 KB (51,200 bytes) of text with a single request.
    #   All input text must be encoded in UTF-8 format.
    # @param text [Array[String]] Input text in UTF-8 encoding. Submit a maximum of 50 KB (51,200 bytes) of text
    #   with a single request. Multiple elements result in multiple translations in the
    #   response.
    # @param model_id [String] The model to use for translation. For example, `en-de` selects the IBM-provided
    #   base model for English-to-German translation. A model ID overrides the `source`
    #   and `target` parameters and is required if you use a custom model. If no model ID
    #   is specified, you must specify at least a target language.
    # @param source [String] Language code that specifies the language of the input text. If omitted, the
    #   service derives the source language from the input text. The input must contain
    #   sufficient text for the service to identify the language reliably.
    # @param target [String] Language code that specifies the target language for translation. Required if
    #   model ID is not specified.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def translate(text:, model_id: nil, source: nil, target: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

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
    # @!method list_identifiable_languages
    # List identifiable languages.
    # Lists the languages that the service can identify. Returns the language code (for
    #   example, `en` for English or `es` for Spanish) and name of each language.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_identifiable_languages
      raise ArgumentError.new("version must be provided") if version.nil?

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

    ##
    # @!method identify(text:)
    # Identify language.
    # Identifies the language of the input text.
    # @param text [String] Input text in UTF-8 format.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def identify(text:)
      raise ArgumentError.new("version must be provided") if version.nil?

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
    #########################
    # Models
    #########################

    ##
    # @!method list_models(source: nil, target: nil, default: nil)
    # List models.
    # Lists available translation models.
    # @param source [String] Specify a language code to filter results by source language.
    # @param target [String] Specify a language code to filter results by target language.
    # @param default [Boolean] If the `default` parameter isn't specified, the service returns all models
    #   (default and non-default) for each language pair. To return only default models,
    #   set this parameter to `true`. To return only non-default models, set this
    #   parameter to `false`. There is exactly one default model, the IBM-provided base
    #   model, per language pair.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_models(source: nil, target: nil, default: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "list_models")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "source" => source,
        "target" => target,
        "default" => default
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

    ##
    # @!method create_model(base_model_id:, forced_glossary: nil, parallel_corpus: nil, name: nil)
    # Create model.
    # Uploads training files to customize a translation model. You can customize a model
    #   with a forced glossary or with a parallel corpus:
    #   * Use a *forced glossary* to force certain terms and phrases to be translated in a
    #   specific way. You can upload only a single forced glossary file for a model. The
    #   size of a forced glossary file for a custom model is limited to 10 MB.
    #   * Use a *parallel corpus* when you want your custom model to learn from general
    #   translation patterns in parallel sentences in your samples. What your model learns
    #   from a parallel corpus can improve translation results for input text that the
    #   model has not been trained on. You can upload multiple parallel corpora files with
    #   a request. To successfully train with parallel corpora, the corpora files must
    #   contain a cumulative total of at least 5000 parallel sentences. The cumulative
    #   size of all uploaded corpus files for a custom model is limited to 250 MB.
    #
    #   Depending on the type of customization and the size of the uploaded files,
    #   training time can range from minutes for a glossary to several hours for a large
    #   parallel corpus. To create a model that is customized with a parallel corpus and a
    #   forced glossary, customize the model with a parallel corpus first and then
    #   customize the resulting model with a forced glossary.
    #
    #   You can create a maximum of 10 custom models per language pair. For more
    #   information about customizing a translation model, including the formatting and
    #   character restrictions for data files, see [Customizing your
    #   model](https://cloud.ibm.com/docs/language-translator?topic=language-translator-customizing).
    #
    #
    #   #### Supported file formats
    #
    #    You can provide your training data for customization in the following document
    #   formats:
    #   * **TMX** (`.tmx`) - Translation Memory eXchange (TMX) is an XML specification for
    #   the exchange of translation memories.
    #   * **XLIFF** (`.xliff`) - XML Localization Interchange File Format (XLIFF) is an
    #   XML specification for the exchange of translation memories.
    #   * **CSV** (`.csv`) - Comma-separated values (CSV) file with two columns for
    #   aligned sentences and phrases. The first row must have two language codes. The
    #   first column is for the source language code, and the second column is for the
    #   target language code.
    #   * **TSV** (`.tsv` or `.tab`) - Tab-separated values (TSV) file with two columns
    #   for aligned sentences and phrases. The first row must have two language codes. The
    #   first column is for the source language code, and the second column is for the
    #   target language code.
    #   * **JSON** (`.json`) - Custom JSON format for specifying aligned sentences and
    #   phrases.
    #   * **Microsoft Excel** (`.xls` or `.xlsx`) - Excel file with the first two columns
    #   for aligned sentences and phrases. The first row contains the language code.
    #
    #   You must encode all text data in UTF-8 format. For more information, see
    #   [Supported document formats for training
    #   data](https://cloud.ibm.com/docs/language-translator?topic=language-translator-customizing#supported-document-formats-for-training-data).
    #
    #
    #   #### Specifying file formats
    #
    #    You can indicate the format of a file by including the file extension with the
    #   file name. Use the file extensions shown in **Supported file formats**.
    #
    #   Alternatively, you can omit the file extension and specify one of the following
    #   `content-type` specifications for the file:
    #   * **TMX** - `application/x-tmx+xml`
    #   * **XLIFF** - `application/xliff+xml`
    #   * **CSV** - `text/csv`
    #   * **TSV** - `text/tab-separated-values`
    #   * **JSON** - `application/json`
    #   * **Microsoft Excel** -
    #   `application/vnd.openxmlformats-officedocument.spreadsheetml.sheet`
    #
    #   For example, with `curl`, use the following `content-type` specification to
    #   indicate the format of a CSV file named **glossary**:
    #
    #   `--form "forced_glossary=@glossary;type=text/csv"`.
    # @param base_model_id [String] The ID of the translation model to use as the base for customization. To see
    #   available models and IDs, use the `List models` method. Most models that are
    #   provided with the service are customizable. In addition, all models that you
    #   create with parallel corpora customization can be further customized with a forced
    #   glossary.
    # @param forced_glossary [File] A file with forced glossary terms for the source and target languages. The
    #   customizations in the file completely overwrite the domain translation data,
    #   including high frequency or high confidence phrase translations.
    #
    #   You can upload only one glossary file for a custom model, and the glossary can
    #   have a maximum size of 10 MB. A forced glossary must contain single words or short
    #   phrases. For more information, see **Supported file formats** in the method
    #   description.
    #
    #   *With `curl`, use `--form forced_glossary=@{filename}`.*.
    # @param parallel_corpus [File] A file with parallel sentences for the source and target languages. You can upload
    #   multiple parallel corpus files in one request by repeating the parameter. All
    #   uploaded parallel corpus files combined must contain at least 5000 parallel
    #   sentences to train successfully. You can provide a maximum of 500,000 parallel
    #   sentences across all corpora.
    #
    #   A single entry in a corpus file can contain a maximum of 80 words. All corpora
    #   files for a custom model can have a cumulative maximum size of 250 MB. For more
    #   information, see **Supported file formats** in the method description.
    #
    #   *With `curl`, use `--form parallel_corpus=@{filename}`.*.
    # @param name [String] An optional model name that you can use to identify the model. Valid characters
    #   are letters, numbers, dashes, underscores, spaces, and apostrophes. The maximum
    #   length of the name is 32 characters.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_model(base_model_id:, forced_glossary: nil, parallel_corpus: nil, name: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

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
      raise ArgumentError.new("version must be provided") if version.nil?

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
    #   successfully completed training has a status of `available`.
    # @param model_id [String] Model ID of the model to get.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_model(model_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

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
    #########################
    # Document translation
    #########################

    ##
    # @!method list_documents
    # List documents.
    # Lists documents that have been submitted for translation.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_documents
      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "list_documents")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/documents"

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
    # @!method translate_document(file:, filename: nil, file_content_type: nil, model_id: nil, source: nil, target: nil, document_id: nil)
    # Translate document.
    # Submit a document for translation. You can submit the document contents in the
    #   `file` parameter, or you can reference a previously submitted document by document
    #   ID. The maximum file size for document translation is
    #   * 20 MB for service instances on the Standard, Advanced, and Premium plans
    #   * 2 MB for service instances on the Lite plan.
    # @param file [File] The contents of the source file to translate. The maximum file size for document
    #   translation is 20 MB for service instances on the Standard, Advanced, and Premium
    #   plans, and 2 MB for service instances on the Lite plan. For more information, see
    #   [Supported file formats
    #   (Beta)](https://cloud.ibm.com/docs/language-translator?topic=language-translator-document-translator-tutorial#supported-file-formats).
    # @param filename [String] The filename for file.
    # @param file_content_type [String] The content type of file.
    # @param model_id [String] The model to use for translation. For example, `en-de` selects the IBM-provided
    #   base model for English-to-German translation. A model ID overrides the `source`
    #   and `target` parameters and is required if you use a custom model. If no model ID
    #   is specified, you must specify at least a target language.
    # @param source [String] Language code that specifies the language of the source document. If omitted, the
    #   service derives the source language from the input text. The input must contain
    #   sufficient text for the service to identify the language reliably.
    # @param target [String] Language code that specifies the target language for translation. Required if
    #   model ID is not specified.
    # @param document_id [String] To use a previously submitted document as the source for a new translation, enter
    #   the `document_id` of the document.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def translate_document(file:, filename: nil, file_content_type: nil, model_id: nil, source: nil, target: nil, document_id: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("file must be provided") if file.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "translate_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      form_data = {}

      unless file.instance_of?(StringIO) || file.instance_of?(File)
        file = file.respond_to?(:to_json) ? StringIO.new(file.to_json) : StringIO.new(file)
      end
      filename = file.path if filename.nil? && file.respond_to?(:path)
      form_data[:file] = HTTP::FormData::File.new(file, content_type: file_content_type.nil? ? "application/octet-stream" : file_content_type, filename: filename)

      form_data[:model_id] = HTTP::FormData::Part.new(model_id.to_s, content_type: "text/plain") unless model_id.nil?

      form_data[:source] = HTTP::FormData::Part.new(source.to_s, content_type: "text/plain") unless source.nil?

      form_data[:target] = HTTP::FormData::Part.new(target.to_s, content_type: "text/plain") unless target.nil?

      form_data[:document_id] = HTTP::FormData::Part.new(document_id.to_s, content_type: "text/plain") unless document_id.nil?

      method_url = "/v3/documents"

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
    # @!method get_document_status(document_id:)
    # Get document status.
    # Gets the translation status of a document.
    # @param document_id [String] The document ID of the document.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_document_status(document_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "get_document_status")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/documents/%s" % [ERB::Util.url_encode(document_id)]

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
    # @!method delete_document(document_id:)
    # Delete document.
    # Deletes a document.
    # @param document_id [String] Document ID of the document to delete.
    # @return [nil]
    def delete_document(document_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "delete_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/documents/%s" % [ERB::Util.url_encode(document_id)]

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
    # @!method get_translated_document(document_id:, accept: nil)
    # Get translated document.
    # Gets the translated document associated with the given document ID.
    # @param document_id [String] The document ID of the document that was submitted for translation.
    # @param accept [String] The type of the response: application/powerpoint, application/mspowerpoint,
    #   application/x-rtf, application/json, application/xml, application/vnd.ms-excel,
    #   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,
    #   application/vnd.ms-powerpoint,
    #   application/vnd.openxmlformats-officedocument.presentationml.presentation,
    #   application/msword,
    #   application/vnd.openxmlformats-officedocument.wordprocessingml.document,
    #   application/vnd.oasis.opendocument.spreadsheet,
    #   application/vnd.oasis.opendocument.presentation,
    #   application/vnd.oasis.opendocument.text, application/pdf, application/rtf,
    #   text/html, text/json, text/plain, text/richtext, text/rtf, or text/xml. A
    #   character encoding can be specified by including a `charset` parameter. For
    #   example, 'text/html;charset=utf-8'.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def get_translated_document(document_id:, accept: nil)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("document_id must be provided") if document_id.nil?

      headers = {
        "Accept" => accept
      }
      sdk_headers = Common.new.get_sdk_headers("language_translator", "V3", "get_translated_document")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v3/documents/%s/translated_document" % [ERB::Util.url_encode(document_id)]

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
