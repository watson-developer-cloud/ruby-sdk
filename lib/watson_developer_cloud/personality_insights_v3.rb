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

# The IBM Watson&trade; Personality Insights service enables applications to derive
# insights from social media, enterprise data, or other digital communications. The
# service uses linguistic analytics to infer individuals' intrinsic personality
# characteristics, including Big Five, Needs, and Values, from digital communications such
# as email, text messages, tweets, and forum posts.
#
# The service can automatically infer, from potentially noisy social media, portraits of
# individuals that reflect their personality characteristics. The service can infer
# consumption preferences based on the results of its analysis and, for JSON content that
# is timestamped, can report temporal behavior.
# * For information about the meaning of the models that the service uses to describe
# personality characteristics, see [Personality
# models](https://console.bluemix.net/docs/services/personality-insights/models.html).
# * For information about the meaning of the consumption preferences, see [Consumption
# preferences](https://console.bluemix.net/docs/services/personality-insights/preferences.html).
#
#
# **Note:** Request logging is disabled for the Personality Insights service. The service
# neither logs nor retains data from requests and responses, regardless of whether the
# `X-Watson-Learning-Opt-Out` request header is set.

require "json"
require_relative "./detailed_response"

require_relative "./watson_service"

module WatsonDeveloperCloud
  ##
  # The Personality Insights V3 service.
  class PersonalityInsightsV3 < WatsonService
    ##
    # @!method initialize(args)
    # Construct a new client for the Personality Insights service.
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
    #   "https://gateway.watsonplatform.net/personality-insights/api").
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
    def initialize(args)
      defaults = {}
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/personality-insights/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_api_key] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      super(
        vcap_services_name: "personality_insights",
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
    # @!method profile(content:, content_type:, accept: nil, content_language: nil, accept_language: nil, raw_scores: nil, csv_headers: nil, consumption_preferences: nil)
    # Get profile.
    # Generates a personality profile for the author of the input text. The service
    #   accepts a maximum of 20 MB of input content, but it requires much less text to
    #   produce an accurate profile; for more information, see [Providing sufficient
    #   input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
    #   The service analyzes text in Arabic, English, Japanese, Korean, or Spanish and
    #   returns its results in a variety of languages. You can provide plain text, HTML,
    #   or JSON input by specifying the **Content-Type** parameter; the default is
    #   `text/plain`. Request a JSON or comma-separated values (CSV) response by
    #   specifying the **Accept** parameter; CSV output includes a fixed number of columns
    #   and optional headers.
    #
    #   Per the JSON specification, the default character encoding for JSON content is
    #   effectively always UTF-8; per the HTTP specification, the default encoding for
    #   plain text and HTML is ISO-8859-1 (effectively, the ASCII character set). When
    #   specifying a content type of plain text or HTML, include the `charset` parameter
    #   to indicate the character encoding of the input text; for example: `Content-Type:
    #   text/plain;charset=utf-8`.
    #
    #   For detailed information about calling the service and the responses it can
    #   generate, see [Requesting a
    #   profile](https://console.bluemix.net/docs/services/personality-insights/input.html),
    #   [Understanding a JSON
    #   profile](https://console.bluemix.net/docs/services/personality-insights/output.html),
    #   and [Understanding a CSV
    #   profile](https://console.bluemix.net/docs/services/personality-insights/output-csv.html).
    # @param content [Content]  A maximum of 20 MB of content to analyze, though the service requires much less
    #   text; for more information, see [Providing sufficient
    #   input](https://console.bluemix.net/docs/services/personality-insights/input.html#sufficient).
    #   For JSON input, provide an object of type `Content`.
    # @param content_type [String]  The type of the input: application/json, text/html, or text/plain. A character
    #   encoding can be specified by including a `charset` parameter. For example,
    #   'text/html;charset=utf-8'.
    # @param accept [String]  The type of the response: application/json or text/csv. A character encoding can
    #   be specified by including a `charset` parameter. For example,
    #   'text/csv;charset=utf-8'.
    # @param content_language [String]  The language of the input text for the request: Arabic, English, Japanese, Korean,
    #   or Spanish. Regional variants are treated as their parent language; for example,
    #   `en-US` is interpreted as `en`.
    #
    #   The effect of the **Content-Language** parameter depends on the **Content-Type**
    #   parameter. When **Content-Type** is `text/plain` or `text/html`,
    #   **Content-Language** is the only way to specify the language. When
    #   **Content-Type** is `application/json`, **Content-Language** overrides a language
    #   specified with the `language` parameter of a `ContentItem` object, and content
    #   items that specify a different language are ignored; omit this parameter to base
    #   the language on the specification of the content items. You can specify any
    #   combination of languages for **Content-Language** and **Accept-Language**.
    # @param accept_language [String]  The desired language of the response. For two-character arguments, regional
    #   variants are treated as their parent language; for example, `en-US` is interpreted
    #   as `en`. You can specify any combination of languages for the input and response
    #   content.
    # @param raw_scores [Boolean]  Indicates whether a raw score in addition to a normalized percentile is returned
    #   for each characteristic; raw scores are not compared with a sample population. By
    #   default, only normalized percentiles are returned.
    # @param csv_headers [Boolean]  Indicates whether column labels are returned with a CSV response. By default, no
    #   column labels are returned. Applies only when the **Accept** parameter is set to
    #   `text/csv`.
    # @param consumption_preferences [Boolean]  Indicates whether consumption preferences are returned with the results. By
    #   default, no consumption preferences are returned.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def profile(content:, content_type:, accept: nil, content_language: nil, accept_language: nil, raw_scores: nil, csv_headers: nil, consumption_preferences: nil)
      raise ArgumentError("content must be provided") if content.nil?
      raise ArgumentError("content_type must be provided") if content_type.nil?
      headers = {
        "Content-Type" => content_type,
        "Accept" => accept,
        "Content-Language" => content_language,
        "Accept-Language" => accept_language
      }
      params = {
        "version" => @version,
        "raw_scores" => raw_scores,
        "csv_headers" => csv_headers,
        "consumption_preferences" => consumption_preferences
      }
      if content_type == "application/json" && content.instance_of?(Hash)
        data = content.to_json
      else
        data = content
      end
      url = "v3/profile"
      response = request(
        method: "POST",
        url: url,
        headers: headers,
        params: params,
        data: data,
        accept_json: true
      )
      response
    end

  end
end
