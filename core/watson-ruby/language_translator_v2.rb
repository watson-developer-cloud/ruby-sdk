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
# The service offers multiple domain-specific models that you can customize based on your
# unique terminology and language. Use Language Translator to take news from across the
# globe and present it in your language, communicate with your customers in their own
# language, and more.

require "json"
require_relative "../detailed_response"

require_relative "../watson_service"

# The Language Translator V2 service.
class LanguageTranslatorV2 < WatsonService
  def initialize(args)
    # Construct a new client for the Language Translator service.
    #
    # :param String url: The base url to use when contacting the service (e.g.
    #   "https://gateway.watsonplatform.net/language-translator/api").
    #   The base url may differ between Bluemix regions.
    # :param String username: The username used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # :param String password: The password used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of Bluemix. When running on
    #   Bluemix, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # :param String iam_api_key: An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # :param String iam_access_token:  An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # :param String iam_url: An optional URL for the IAM service API. Defaults to
    #   'https://iam.ng.bluemix.net/identity/token'.
    defaults = {}
    defaults[:url] = "https://gateway.watsonplatform.net/language-translator/api"
    defaults[:username] = nil
    defaults[:password] = nil
    defaults[:iam_api_key] = nil
    defaults[:iam_access_token] = nil
    defaults[:iam_url] = nil
    args = defaults.merge(args)
    super(
      vcap_services_name: "language_translator",
      url: args[:url],
      username: args[:username],
      password: args[:password],
      iam_api_key: args[:iam_api_key],
      iam_access_token: args[:iam_access_token],
      iam_url: args[:iam_url],
      use_vcap_services: true
    )
  end
  #########################
  # Translation
  #########################

  def translate(text:, model_id: nil, source: nil, target: nil)
    # Translate
    #
    # Translates the input text from the source language to the target language.
    #
    # :param list[String] text: Input text in UTF-8 encoding. Multiple entries will result in multiple
    #   translations in the response.
    # :param String model_id: Model ID of the translation model to use. If this is specified, the **source** and
    #   **target** parameters will be ignored. The method requires either a model ID or
    #   both the **source** and **target** parameters.
    # :param String source: Language code of the source text language. Use with `target` as an alternative way
    #   to select a translation model. When `source` and `target` are set, and a model ID
    #   is not set, the system chooses a default model for the language pair (usually the
    #   model based on the news domain).
    # :param String target: Language code of the translation target language. Use with source as an
    #   alternative way to select a translation model.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    data = {
      "text" => text,
      "model_id" => model_id,
      "source" => source,
      "target" => target
    }
    url = "v2/translate"
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      json: data,
      accept_json: true
    )
    response
  end

  #########################
  # Identification
  #########################

  def list_identifiable_languages()
    # List identifiable languages
    #
    # Lists the languages that the service can identify. Returns the language code
    #   (for example, `en` for English or `es` for Spanish) and name of each language.
    #
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    headers = {
    }
    url = "v2/identifiable_languages"
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      accept_json: true
    )
    response
  end

  def identify(text:)
    # Identify language
    #
    # Identifies the language of the input text.
    #
    # :param String text: Input text in UTF-8 format.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    data = text
    headers = {"content-type" => "text/plain"}
    url = "v2/identify"
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      data: data,
      accept_json: true
    )
    response
  end

  #########################
  # Models
  #########################

  def list_models(source: nil, target: nil, default_models: nil)
    # List models
    #
    # Lists available translation models.
    #
    # :param String source: Specify a language code to filter results by source language.
    # :param String target: Specify a language code to filter results by target language.
    # :param Boolean default_models: If the default parameter isn't specified, the service will return all models
    #   (default and non-default) for each language pair. To return only default models,
    #   set this to `true`. To return only non-default models, set this to `false`.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    headers = {
    }
    params = {
      "source" => source,
      "target" => target,
      "default" => default_models
    }
    url = "v2/models"
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_model(base_model_id:, name: nil, forced_glossary: nil, parallel_corpus: nil, monolingual_corpus: nil, forced_glossary_filename: nil, parallel_corpus_filename: nil, monolingual_corpus_filename: nil)
    # Create model
    #
    # Uploads a TMX glossary file on top of a domain to customize a translation model.
    #
    #   Depending on the size of the file, training can range from minutes for a glossary
    #   to several hours for a large parallel corpus. Glossary files must be less than 10
    #   MB. The cumulative file size of all uploaded glossary and corpus files is limited
    #   to 250 MB.
    #
    # :param String base_model_id: The model ID of the model to use as the base for customization. To see available
    #   models, use the `List models` method.
    # :param String name: An optional model name that you can use to identify the model. Valid characters
    #   are letters, numbers, dashes, underscores, spaces and apostrophes. The maximum
    #   length is 32 characters.
    # :param File forced_glossary: A TMX file with your customizations. The customizations in the file completely
    #   overwrite the domain translaton data, including high frequency or high confidence
    #   phrase translations. You can upload only one glossary with a file size less than
    #   10 MB per call.
    # :param File parallel_corpus: A TMX file that contains entries that are treated as a parallel corpus instead of
    #   a glossary.
    # :param File monolingual_corpus: A UTF-8 encoded plain text file that is used to customize the target language
    #   model.
    # :param String forced_glossary_filename: The filename for forced_glossary.
    # :param String parallel_corpus_filename: The filename for parallel_corpus.
    # :param String monolingual_corpus_filename: The filename for monolingual_corpus.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("base_model_id must be provided") if base_model_id.nil?
    headers = {
    }
    params = {
      "base_model_id" => base_model_id,
      "name" => name
    }
    forced_glossary_tuple = nil
    if forced_glossary
      forced_glossary_filename = forced_glossary.name if !forced_glossary_filename && forced_glossary.instance_variable_defined?("name")
      mime_type = "application/octet-stream"
      forced_glossary_tuple = [forced_glossary_filename, forced_glossary, mime_type]
    end
    parallel_corpus_tuple = nil
    if parallel_corpus
      parallel_corpus_filename = parallel_corpus.name if !parallel_corpus_filename && parallel_corpus.instance_variable_defined?("name")
      mime_type = "application/octet-stream"
      parallel_corpus_tuple = [parallel_corpus_filename, parallel_corpus, mime_type]
    end
    monolingual_corpus_tuple = nil
    if monolingual_corpus
      monolingual_corpus_filename = monolingual_corpus.name if !monolingual_corpus_filename && monolingual_corpus.instance_variable_defined?("name")
      mime_type = "text/plain"
      monolingual_corpus_tuple = [monolingual_corpus_filename, monolingual_corpus, mime_type]
    end
    url = "v2/models"
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      files: {
        "forced_glossary" => forced_glossary_tuple,
        "parallel_corpus" => parallel_corpus_tuple,
        "monolingual_corpus" => monolingual_corpus_tuple
      },
      accept_json: true
    )
    response
  end

  def delete_model(model_id:)
    # Delete model
    #
    # Deletes a custom translation model.
    #
    # :param String model_id: Model ID of the model to delete.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("model_id must be provided") if model_id.nil?
    headers = {
    }
    url = "v2/models/%s" % [CGI.escape(model_id)]
    response = request(
      method: "DELETE",
      url: url,
      headers: headers,
      accept_json: true
    )
    response
  end

  def get_model(model_id:)
    # Get model details
    #
    # Gets information about a translation model, including training status for custom
    #   models.
    #
    # :param String model_id: Model ID of the model to get.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("model_id must be provided") if model_id.nil?
    headers = {
    }
    url = "v2/models/%s" % [CGI.escape(model_id)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      accept_json: true
    )
    response
  end

end