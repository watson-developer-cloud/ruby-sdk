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

# The IBM Watson&trade; Assistant service combines machine learning, natural language
# understanding, and integrated dialog tools to create conversation flows between your
# apps and your users.

require "concurrent"
require "erb"
require "json"
require_relative "./detailed_response"

require_relative "./watson_service"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Assistant V2 service.
  class AssistantV2 < WatsonService
    include Concurrent::Async
    ##
    # @!method initialize(args)
    # Construct a new client for the Assistant service.
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
    #   "https://gateway.watsonplatform.net/assistant/api").
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
      defaults[:url] = "https://gateway.watsonplatform.net/assistant/api"
      defaults[:username] = nil
      defaults[:password] = nil
      defaults[:iam_apikey] = nil
      defaults[:iam_access_token] = nil
      defaults[:iam_url] = nil
      args = defaults.merge(args)
      args[:vcap_services_name] = "conversation"
      super
      @version = args[:version]
    end

    #########################
    # Sessions
    #########################

    ##
    # @!method create_session(assistant_id:)
    # Create a session.
    # Create a new session. A session is used to send user input to a skill and receive
    #   responses. It also maintains the state of the conversation.
    # @param assistant_id [String] Unique identifier of the assistant. You can find the assistant ID of an assistant
    #   on the **Assistants** tab of the Watson Assistant tool. For information about
    #   creating assistants, see the
    #   [documentation](https://console.bluemix.net/docs/services/assistant/create-assistant.html#creating-assistants).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def create_session(assistant_id:)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      headers = {
      }

      params = {
        "version" => @version
      }

      method_url = "/v2/assistants/%s/sessions" % [ERB::Util.url_encode(assistant_id)]

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
    # @!method delete_session(assistant_id:, session_id:)
    # Delete session.
    # Deletes a session explicitly before it times out.
    # @param assistant_id [String] Unique identifier of the assistant. You can find the assistant ID of an assistant
    #   on the **Assistants** tab of the Watson Assistant tool. For information about
    #   creating assistants, see the
    #   [documentation](https://console.bluemix.net/docs/services/assistant/create-assistant.html#creating-assistants).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param session_id [String] Unique identifier of the session.
    # @return [nil]
    def delete_session(assistant_id:, session_id:)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("session_id must be provided") if session_id.nil?

      headers = {
      }

      params = {
        "version" => @version
      }

      method_url = "/v2/assistants/%s/sessions/%s" % [ERB::Util.url_encode(assistant_id), ERB::Util.url_encode(session_id)]

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
    # Message
    #########################

    ##
    # @!method message(assistant_id:, session_id:, input: nil, context: nil)
    # Send user input to assistant.
    # Send user input to an assistant and receive a response.
    #
    #   There is no rate limit for this operation.
    # @param assistant_id [String] Unique identifier of the assistant. You can find the assistant ID of an assistant
    #   on the **Assistants** tab of the Watson Assistant tool. For information about
    #   creating assistants, see the
    #   [documentation](https://console.bluemix.net/docs/services/assistant/create-assistant.html#creating-assistants).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param session_id [String] Unique identifier of the session.
    # @param input [MessageInput] The user input.
    # @param context [MessageContext] State information for the conversation.
    # @return [DetailedResponse] A `DetailedResponse` object representing the response.
    def message(assistant_id:, session_id:, input: nil, context: nil)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("session_id must be provided") if session_id.nil?

      headers = {
      }

      params = {
        "version" => @version
      }

      data = {
        "input" => input,
        "context" => context
      }

      method_url = "/v2/assistants/%s/sessions/%s/message" % [ERB::Util.url_encode(assistant_id), ERB::Util.url_encode(session_id)]

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
