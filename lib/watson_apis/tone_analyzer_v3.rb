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

# The IBM Watson&trade; Tone Analyzer service uses linguistic analysis to detect
# emotional and language tones in written text. The service can analyze tone at both the
# document and sentence levels. You can use the service to understand how your written
# communications are perceived and then to improve the tone of your communications.
# Businesses can use the service to learn the tone of their customers' communications and
# to respond to each customer appropriately, or to understand and improve their customer
# conversations.
#
# **Note:** Request logging is disabled for the Tone Analyzer service. The service neither
# logs nor retains data from requests and responses, regardless of whether the
# `X-Watson-Learning-Opt-Out` request header is set.

require "json"
require_relative "./detailed_response"

require_relative "./watson_service"

module WatsonAPIs
  ##
  # The Tone Analyzer V3 service.
  class ToneAnalyzerV3 < WatsonService
    ##
    # @!method initialize(args)
    # Construct a new client for the Tone Analyzer service.
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
    #   "https://gateway.watsonplatform.net/tone-analyzer/api").
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
    # @option args iam_api_key [String] An API key that can be used to request IAM tokens. If
    #   this API key is provided, the SDK will manage the token and handle the
    #   refreshing.
    # @option args iam_access_token [String] An IAM access token is fully managed by the application.
    #   Responsibility falls on the application to refresh the token, either before
    #   it expires or reactively upon receiving a 401 from the service as any requests
    #   made with an expired token will fail.
    # @option args iam_url [String] An optional URL for the IAM service API. Defaults to
    #   'https://iam.ng.bluemix.net/identity/token'.
    def initialize(args = {})
      defaults = {}
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/tone-analyzer/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_api_key] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      super(
        vcap_services_name: "tone_analyzer",
        url: args[:url],
        username: args[:username],
        password: args[:password],
        iam_api_key: args[:iam_api_key],
        iam_access_token: args[:iam_access_token],
        iam_url: args[:iam_url],
        use_vcap_services: true
      )
      @version = args[:version]
    end
    #########################
    # Methods
    #########################

    ##
    # @!method tone(tone_input:, content_type:, sentences: nil, tones: nil, content_language: nil, accept_language: nil)
    # Analyze general tone.
    # Use the general purpose endpoint to analyze the tone of your input content. The
    #   service analyzes the content for emotional and language tones. The method always
    #   analyzes the tone of the full document; by default, it also analyzes the tone of
    #   each individual sentence of the content.
    #
    #   You can submit no more than 128 KB of total input content and no more than 1000
    #   individual sentences in JSON, plain text, or HTML format. The service analyzes the
    #   first 1000 sentences for document-level analysis and only the first 100 sentences
    #   for sentence-level analysis.
    #
    #   Per the JSON specification, the default character encoding for JSON content is
    #   effectively always UTF-8; per the HTTP specification, the default encoding for
    #   plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When
    #   specifying a content type of plain text or HTML, include the `charset` parameter
    #   to indicate the character encoding of the input text; for example: `Content-Type:
    #   text/plain;charset=utf-8`. For `text/html`, the service removes HTML tags and
    #   analyzes only the textual content.
    # @param tone_input [ToneInput] JSON, plain text, or HTML input that contains the content to be analyzed. For JSON
    #   input, provide an object of type `ToneInput`.
    # @param content_type [String] The type of the input. A character encoding can be specified by including a
    #   `charset` parameter. For example, 'text/plain;charset=utf-8'.
    # @param sentences [Boolean] Indicates whether the service is to return an analysis of each individual sentence
    #   in addition to its analysis of the full document. If `true` (the default), the
    #   service returns results for each sentence.
    # @param tones [Array[String]] **`2017-09-21`:** Deprecated. The service continues to accept the parameter for
    #   backward-compatibility, but the parameter no longer affects the response.
    #
    #   **`2016-05-19`:** A comma-separated list of tones for which the service is to
    #   return its analysis of the input; the indicated tones apply both to the full
    #   document and to individual sentences of the document. You can specify one or more
    #   of the valid values. Omit the parameter to request results for all three tones.
    # @param content_language [String] The language of the input text for the request: English or French. Regional
    #   variants are treated as their parent language; for example, `en-US` is interpreted
    #   as `en`. The input content must match the specified language. Do not submit
    #   content that contains both languages. You can use different languages for
    #   **Content-Language** and **Accept-Language**.
    #   * **`2017-09-21`:** Accepts `en` or `fr`.
    #   * **`2016-05-19`:** Accepts only `en`.
    # @param accept_language [String] The desired language of the response. For two-character arguments, regional
    #   variants are treated as their parent language; for example, `en-US` is interpreted
    #   as `en`. You can use different languages for **Content-Language** and
    #   **Accept-Language**.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def tone(tone_input:, content_type:, sentences: nil, tones: nil, content_language: nil, accept_language: nil)
      raise ArgumentError("tone_input must be provided") if tone_input.nil?
      raise ArgumentError("content_type must be provided") if content_type.nil?
      headers = {
        "Content-Type" => content_type,
        "Content-Language" => content_language,
        "Accept-Language" => accept_language
      }
      params = {
        "version" => @version,
        "sentences" => sentences,
        "tones" => tones.to_a
      }
      if content_type == "application/json" && tone_input.instance_of?(Hash)
        data = tone_input.to_json
      else
        data = tone_input
      end
      method_url = "/v3/tone"
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
    # @!method tone_chat(utterances:, content_language: nil, accept_language: nil)
    # Analyze customer engagement tone.
    # Use the customer engagement endpoint to analyze the tone of customer service and
    #   customer support conversations. For each utterance of a conversation, the method
    #   reports the most prevalent subset of the following seven tones: sad, frustrated,
    #   satisfied, excited, polite, impolite, and sympathetic.
    #
    #   If you submit more than 50 utterances, the service returns a warning for the
    #   overall content and analyzes only the first 50 utterances. If you submit a single
    #   utterance that contains more than 500 characters, the service returns an error for
    #   that utterance and does not analyze the utterance. The request fails if all
    #   utterances have more than 500 characters.
    #
    #   Per the JSON specification, the default character encoding for JSON content is
    #   effectively always UTF-8.
    # @param utterances [Array[Utterance]] An array of `Utterance` objects that provides the input content that the service
    #   is to analyze.
    # @param content_language [String] The language of the input text for the request: English or French. Regional
    #   variants are treated as their parent language; for example, `en-US` is interpreted
    #   as `en`. The input content must match the specified language. Do not submit
    #   content that contains both languages. You can use different languages for
    #   **Content-Language** and **Accept-Language**.
    #   * **`2017-09-21`:** Accepts `en` or `fr`.
    #   * **`2016-05-19`:** Accepts only `en`.
    # @param accept_language [String] The desired language of the response. For two-character arguments, regional
    #   variants are treated as their parent language; for example, `en-US` is interpreted
    #   as `en`. You can use different languages for **Content-Language** and
    #   **Accept-Language**.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def tone_chat(utterances:, content_language: nil, accept_language: nil)
      raise ArgumentError("utterances must be provided") if utterances.nil?
      headers = {
        "Content-Language" => content_language,
        "Accept-Language" => accept_language
      }
      params = {
        "version" => @version
      }
      data = {
        "utterances" => utterances
      }
      method_url = "/v3/tone_chat"
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
  end
end
