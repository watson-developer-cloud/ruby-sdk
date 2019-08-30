# frozen_string_literal: true

# (C) Copyright IBM Corp. 2019.
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
# understanding, and an integrated dialog editor to create conversation flows between your
# apps and your users.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

# Module for the Watson APIs
module IBMWatson
  ##
  # The Assistant V2 service.
  class AssistantV2 < IBMCloudSdkCore::BaseService
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
    #   The base url may differ between IBM Cloud regions.
    # @option args username [String] The username used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of IBM Cloud. When running on
    #   IBM Cloud, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
    # @option args password [String] The password used to authenticate with the service.
    #   Username and password credentials are only required to run your
    #   application locally or outside of IBM Cloud. When running on
    #   IBM Cloud, the credentials will be automatically loaded from the
    #   `VCAP_SERVICES` environment variable.
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
    # @option args icp4d_access_token [STRING]  A ICP4D(IBM Cloud Pak for Data) access token is
    #   fully managed by the application. Responsibility falls on the application to
    #   refresh the token, either before it expires or reactively upon receiving a 401
    #   from the service as any requests made with an expired token will fail.
    # @option args icp4d_url [STRING] In order to use an SDK-managed token with ICP4D authentication, this
    #   URL must be passed in.
    # @option args authentication_type [STRING] Specifies the authentication pattern to use. Values that it
    #   takes are basic, iam or icp4d.
    def initialize(args = {})
      @__async_initialized__ = false
      defaults = {}
      defaults[:version] = nil
      defaults[:url] = "https://gateway.watsonplatform.net/assistant/api"
      defaults[:authenticator] = nil
      defaults[:authentication_type] = nil
      args = defaults.merge(args)
      @version = args[:version]
      raise ArgumentError.new("version must be provided") if @version.nil?

      args[:display_name] = "Assistant"
      super
    end

    #########################
    # Sessions
    #########################

    ##
    # @!method create_session(assistant_id:)
    # Create a session.
    # Create a new session. A session is used to send user input to a skill and receive
    #   responses. It also maintains the state of the conversation.
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/services/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_session(assistant_id:)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "create_session")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/assistants/%s/sessions" % [ERB::Util.url_encode(assistant_id)]

      headers = authenticator.authenticate(headers)
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
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/services/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param session_id [String] Unique identifier of the session.
    # @return [nil]
    def delete_session(assistant_id:, session_id:)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("session_id must be provided") if session_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "delete_session")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      method_url = "/v2/assistants/%s/sessions/%s" % [ERB::Util.url_encode(assistant_id), ERB::Util.url_encode(session_id)]

      headers = authenticator.authenticate(headers)
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
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/services/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param session_id [String] Unique identifier of the session.
    # @param input [MessageInput] An input object that includes the input text.
    # @param context [MessageContext] State information for the conversation. The context is stored by the assistant on
    #   a per-session basis. You can use this property to set or modify context variables,
    #   which can also be accessed by dialog nodes.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def message(assistant_id:, session_id:, input: nil, context: nil)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("session_id must be provided") if session_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "message")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "input" => input,
        "context" => context
      }

      method_url = "/v2/assistants/%s/sessions/%s/message" % [ERB::Util.url_encode(assistant_id), ERB::Util.url_encode(session_id)]

      headers = authenticator.authenticate(headers)
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
