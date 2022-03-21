# frozen_string_literal: true

# (C) Copyright IBM Corp. 2018, 2022.
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
# IBM OpenAPI SDK Code Generator Version: 3.38.0-07189efd-20210827-205025
#
# The IBM Watson&trade; Assistant service combines machine learning, natural language
# understanding, and an integrated dialog editor to create conversation flows between your
# apps and your users.
#
# The Assistant v2 API provides runtime methods your client application can use to send
# user input to an assistant and receive a response.

require "concurrent"
require "erb"
require "json"
require "ibm_cloud_sdk_core"
require_relative "./common.rb"

module IBMWatson
  ##
  # The Assistant V2 service.
  class AssistantV2 < IBMCloudSdkCore::BaseService
    include Concurrent::Async
    DEFAULT_SERVICE_NAME = "assistant"
    DEFAULT_SERVICE_URL = "https://api.us-south.assistant.watson.cloud.ibm.com"
    attr_accessor :version
    ##
    # @!method initialize(args)
    # Construct a new client for the Assistant service.
    #
    # @param args [Hash] The args to initialize with
    # @option args version [String] Release date of the API version you want to use. Specify dates in YYYY-MM-DD
    #   format. The current version is `2021-11-27`.
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
    # Sessions
    #########################

    ##
    # @!method create_session(assistant_id:)
    # Create a session.
    # Create a new session. A session is used to send user input to a skill and receive
    #   responses. It also maintains the state of the conversation. A session persists
    #   until it is deleted, or until it times out because of inactivity. (For more
    #   information, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-settings).
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def create_session(assistant_id:)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "create_session")
      headers.merge!(sdk_headers)

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
    # Deletes a session explicitly before it times out. (For more information about the
    #   session inactivity timeout, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-settings)).
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param session_id [String] Unique identifier of the session.
    # @return [nil]
    def delete_session(assistant_id:, session_id:)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("session_id must be provided") if session_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "delete_session")
      headers.merge!(sdk_headers)

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
    # @!method message(assistant_id:, session_id:, input: nil, context: nil, user_id: nil)
    # Send user input to assistant (stateful).
    # Send user input to an assistant and receive a response, with conversation state
    #   (including context data) stored by Watson Assistant for the duration of the
    #   session.
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param session_id [String] Unique identifier of the session.
    # @param input [MessageInput] An input object that includes the input text.
    # @param context [MessageContext] Context data for the conversation. You can use this property to set or modify
    #   context variables, which can also be accessed by dialog nodes. The context is
    #   stored by the assistant on a per-session basis.
    #
    #   **Note:** The total size of the context data stored for a stateful session cannot
    #   exceed 100KB.
    # @param user_id [String] A string value that identifies the user who is interacting with the assistant. The
    #   client must provide a unique identifier for each individual end user who accesses
    #   the application. For user-based plans, this user ID is used to identify unique
    #   users for billing purposes. This string cannot contain carriage return, newline,
    #   or tab characters. If no value is specified in the input, **user_id** is
    #   automatically set to the value of **context.global.session_id**.
    #
    #   **Note:** This property is the same as the **user_id** property in the global
    #   system context. If **user_id** is specified in both locations, the value specified
    #   at the root is used.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def message(assistant_id:, session_id:, input: nil, context: nil, user_id: nil)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("session_id must be provided") if session_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "message")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "input" => input,
        "context" => context,
        "user_id" => user_id
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

    ##
    # @!method message_stateless(assistant_id:, input: nil, context: nil, user_id: nil)
    # Send user input to assistant (stateless).
    # Send user input to an assistant and receive a response, with conversation state
    #   (including context data) managed by your application.
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param input [MessageInputStateless] An input object that includes the input text.
    # @param context [MessageContextStateless] Context data for the conversation. You can use this property to set or modify
    #   context variables, which can also be accessed by dialog nodes. The context is not
    #   stored by the assistant. To maintain session state, include the context from the
    #   previous response.
    #
    #   **Note:** The total size of the context data for a stateless session cannot exceed
    #   250KB.
    # @param user_id [String] A string value that identifies the user who is interacting with the assistant. The
    #   client must provide a unique identifier for each individual end user who accesses
    #   the application. For user-based plans, this user ID is used to identify unique
    #   users for billing purposes. This string cannot contain carriage return, newline,
    #   or tab characters. If no value is specified in the input, **user_id** is
    #   automatically set to the value of **context.global.session_id**.
    #
    #   **Note:** This property is the same as the **user_id** property in the global
    #   system context. If **user_id** is specified in both locations in a message
    #   request, the value specified at the root is used.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def message_stateless(assistant_id:, input: nil, context: nil, user_id: nil)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "message_stateless")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "input" => input,
        "context" => context,
        "user_id" => user_id
      }

      method_url = "/v2/assistants/%s/message" % [ERB::Util.url_encode(assistant_id)]

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
    # Bulk classify
    #########################

    ##
    # @!method bulk_classify(skill_id:, input: nil)
    # Identify intents and entities in multiple user utterances.
    # Send multiple user inputs to a dialog skill in a single request and receive
    #   information about the intents and entities recognized in each input. This method
    #   is useful for testing and comparing the performance of different skills or skill
    #   versions.
    #
    #   This method is available only with Enterprise with Data Isolation plans.
    # @param skill_id [String] Unique identifier of the skill. To find the skill ID in the Watson Assistant user
    #   interface, open the skill settings and click **API Details**.
    # @param input [Array[BulkClassifyUtterance]] An array of input utterances to classify.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def bulk_classify(skill_id:, input: nil)
      raise ArgumentError.new("skill_id must be provided") if skill_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "bulk_classify")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version
      }

      data = {
        "input" => input
      }

      method_url = "/v2/skills/%s/workspace/bulk_classify" % [ERB::Util.url_encode(skill_id)]

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
    # Logs
    #########################

    ##
    # @!method list_logs(assistant_id:, sort: nil, filter: nil, page_limit: nil, cursor: nil)
    # List log events for an assistant.
    # List the events from the log of an assistant.
    #
    #   This method requires Manager access, and is available only with Enterprise plans.
    # @param assistant_id [String] Unique identifier of the assistant. To find the assistant ID in the Watson
    #   Assistant user interface, open the assistant settings and click **API Details**.
    #   For information about creating assistants, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-assistant-add#assistant-add-task).
    #
    #   **Note:** Currently, the v2 API does not support creating assistants.
    # @param sort [String] How to sort the returned log events. You can sort by **request_timestamp**. To
    #   reverse the sort order, prefix the parameter value with a minus sign (`-`).
    # @param filter [String] A cacheable parameter that limits the results to those matching the specified
    #   filter. For more information, see the
    #   [documentation](https://cloud.ibm.com/docs/assistant?topic=assistant-filter-reference#filter-reference).
    # @param page_limit [Fixnum] The number of records to return in each page of results.
    # @param cursor [String] A token identifying the page of results to retrieve.
    # @return [IBMCloudSdkCore::DetailedResponse] A `IBMCloudSdkCore::DetailedResponse` object representing the response.
    def list_logs(assistant_id:, sort: nil, filter: nil, page_limit: nil, cursor: nil)
      raise ArgumentError.new("assistant_id must be provided") if assistant_id.nil?

      raise ArgumentError.new("version must be provided") if version.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "list_logs")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "sort" => sort,
        "filter" => filter,
        "page_limit" => page_limit,
        "cursor" => cursor
      }

      method_url = "/v2/assistants/%s/logs" % [ERB::Util.url_encode(assistant_id)]

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
    #   security](https://cloud.ibm.com/docs/assistant?topic=assistant-information-security#information-security).
    #
    #   **Note:** This operation is intended only for deleting data associated with a
    #   single specific customer, not for deleting data associated with multiple customers
    #   or for any other purpose. For more information, see [Labeling and deleting data in
    #   Watson
    #   Assistant](https://cloud.ibm.com/docs/assistant?topic=assistant-information-security#information-security-gdpr-wa).
    # @param customer_id [String] The customer ID for which all data is to be deleted.
    # @return [nil]
    def delete_user_data(customer_id:)
      raise ArgumentError.new("version must be provided") if version.nil?

      raise ArgumentError.new("customer_id must be provided") if customer_id.nil?

      headers = {
      }
      sdk_headers = Common.new.get_sdk_headers("conversation", "V2", "delete_user_data")
      headers.merge!(sdk_headers)

      params = {
        "version" => @version,
        "customer_id" => customer_id
      }

      method_url = "/v2/user_data"

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
