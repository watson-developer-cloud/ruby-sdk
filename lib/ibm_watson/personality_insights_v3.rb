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
# models](https://cloud.ibm.com/docs/services/personality-insights/models.html).
# * For information about the meaning of the consumption preferences, see [Consumption
# preferences](https://cloud.ibm.com/docs/services/personality-insights/preferences.html).
#
#
# **Note:** Request logging is disabled for the Personality Insights service. Regardless
# of whether you set the `X-Watson-Learning-Opt-Out` request header, the service does not
# log or retain data from requests and responses.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Personality Insights V3 service.
  class PersonalityInsightsV3 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
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
      defaults[:url] = "https://gateway.watsonplatform.net/personality-insights/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "personality_insights"
      super
      @version = args[:version]
      args[:display_name] = "Personality Insights"
    end

    #########################
    # Methods
    #########################

    ##
    # @!method profile(content:, accept:, content_language: nil, accept_language: nil, raw_scores: nil, csv_headers: nil, consumption_preferences: nil, content_type: nil)
    # Get profile.
    # Generates a personality profile for the author of the input text. The service
    #   accepts a maximum of 20 MB of input content, but it requires much less text to
    #   produce an accurate profile. The service can analyze text in Arabic, English,
    #   Japanese, Korean, or Spanish. It can return its results in a variety of languages.
    #
    #
    #   **See also:**
    #   * [Requesting a
    #   profile](https://cloud.ibm.com/docs/services/personality-insights/input.html)
    #   * [Providing sufficient
    #   input](https://cloud.ibm.com/docs/services/personality-insights/input.html#sufficient)
    #
    #
    #   ### Content types
    #
    #    You can provide input content as plain text (`text/plain`), HTML (`text/html`),
    #   or JSON (`application/json`) by specifying the **Content-Type** parameter. The
    #   default is `text/plain`.
    #   * Per the JSON specification, the default character encoding for JSON content is
    #   effectively always UTF-8.
    #   * Per the HTTP specification, the default encoding for plain text and HTML is
    #   ISO-8859-1 (effectively, the ASCII character set).
    #
    #   When specifying a content type of plain text or HTML, include the `charset`
    #   parameter to indicate the character encoding of the input text; for example,
    #   `Content-Type: text/plain;charset=utf-8`.
    #
    #   **See also:** [Specifying request and response
    #   formats](https://cloud.ibm.com/docs/services/personality-insights/input.html#formats)
    #
    #
    #   ### Accept types
    #
    #    You must request a response as JSON (`application/json`) or comma-separated
    #   values (`text/csv`) by specifying the **Accept** parameter. CSV output includes a
    #   fixed number of columns. Set the **csv_headers** parameter to `true` to request
    #   optional column headers for CSV output.
    #
    #   **See also:**
    #   * [Understanding a JSON
    #   profile](https://cloud.ibm.com/docs/services/personality-insights/output.html)
    #   * [Understanding a CSV
    #   profile](https://cloud.ibm.com/docs/services/personality-insights/output-csv.html).
    # @param content [Content] A maximum of 20 MB of content to analyze, though the service requires much less
    #   text; for more information, see [Providing sufficient
    #   input](https://cloud.ibm.com/docs/services/personality-insights/input.html#sufficient).
    #   For JSON input, provide an object of type `Content`.
    # @param accept [String] The type of the response. For more information, see **Accept types** in the method
    #   description.
    # @param content_language [String] The language of the input text for the request: Arabic, English, Japanese, Korean,
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
    # @param accept_language [String] The desired language of the response. For two-character arguments, regional
    #   variants are treated as their parent language; for example, `en-US` is interpreted
    #   as `en`. You can specify any combination of languages for the input and response
    #   content.
    # @param raw_scores [Boolean] Indicates whether a raw score in addition to a normalized percentile is returned
    #   for each characteristic; raw scores are not compared with a sample population. By
    #   default, only normalized percentiles are returned.
    # @param csv_headers [Boolean] Indicates whether column labels are returned with a CSV response. By default, no
    #   column labels are returned. Applies only when the response type is CSV
    #   (`text/csv`).
    # @param consumption_preferences [Boolean] Indicates whether consumption preferences are returned with the results. By
    #   default, no consumption preferences are returned.
    # @param content_type [String] The type of the input. For more information, see **Content types** in the method
    #   description.
    #
    #   Default: `text/plain`.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def profile(content:, accept:, content_language: nil, accept_language: nil, raw_scores: nil, csv_headers: nil, consumption_preferences: nil, content_type: nil)
      raise ArgumentError.new("content must be provided") if content.nil?

      raise ArgumentError.new("accept must be provided") if accept.nil?

      headers = {
        "Accept" => accept,
        "Content-Language" => content_language,
        "Accept-Language" => accept_language,
        "Content-Type" => content_type
      }
      sdk_headers = Common.new.get_sdk_headers("personality_insights", "V3", "profile")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "raw_scores" => raw_scores,
        "csv_headers" => csv_headers,
        "consumption_preferences" => consumption_preferences
      }

      if content_type.start_with?("application/json") && content.instance_of?(Hash)
        data = content.to_json
      else
        data = content
      end

      method_url = "/v3/profile"

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
  end
end
