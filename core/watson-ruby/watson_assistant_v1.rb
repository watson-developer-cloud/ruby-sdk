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

require "json"
require_relative "../detailed_response"

require_relative "../watson_service"

# The Assistant V1 service.
class AssistantV1 < WatsonService
  def initialize(args)
    # Construct a new client for the Assistant service.
    #
    # :param String version: The API version date to use with the service, in
    #   "YYYY-MM-DD" format. Whenever the API is changed in a backwards
    #   incompatible way, a new minor version of the API is released.
    #   The service uses the API version for the date you specify, or
    #   the most recent version before that date. Note that you should
    #   not programmatically specify the current date at runtime, in
    #   case the API has been updated since your application's release.
    #   Instead, specify a version date that is compatible with your
    #   application, and don't change it until your application is
    #   ready for a later version.
    # :param String url: The base url to use when contacting the service (e.g.
    #   "https://gateway.watsonplatform.net/assistant/api").
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
    defaults[:version] = nil
    defaults[:url] = "https://gateway.watsonplatform.net/assistant/api"
    defaults[:username] = nil
    defaults[:password] = nil
    defaults[:iam_api_key] = nil
    defaults[:iam_access_token] = nil
    defaults[:iam_url] = nil
    args = defaults.merge(args)
    super(
      vcap_services_name: "conversation",
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
  # Message
  #########################

  def message(workspace_id:, input: nil, alternate_intents: nil, context: nil, entities: nil, intents: nil, output: nil, nodes_visited_details: nil)
    # Get response to user input
    #
    # Get a response to a user's input.
    #
    #   There is no rate limit for this operation.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param InputData input: An input object that includes the input text.
    # :param Boolean alternate_intents: Whether to return more than one intent. Set to `true` to return all matching
    #   intents.
    # :param Context context: State information for the conversation. Continue a conversation by including the
    #   context object from the previous response.
    # :param list[RuntimeEntity] entities: Entities to use when evaluating the message. Include entities from the previous
    #   response to continue using those entities rather than detecting entities in the
    #   new input.
    # :param list[RuntimeIntent] intents: Intents to use when evaluating the user input. Include intents from the previous
    #   response to continue using those intents rather than trying to recognize intents
    #   in the new input.
    # :param OutputData output: System output. Include the output from the previous response to maintain
    #   intermediate information over multiple requests.
    # :param Boolean nodes_visited_details: Whether to include additional diagnostic information about the dialog nodes that
    #   were visited during processing of the message.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "nodes_visited_details" => nodes_visited_details
    }
    data = {
      "input" => input,
      "alternate_intents" => alternate_intents,
      "context" => context,
      "entities" => entities,
      "intents" => intents,
      "output" => output
    }
    url = "v1/workspaces/%s/message" % [CGI.escape(workspace_id)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  #########################
  # Workspaces
  #########################

  def list_workspaces(page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List workspaces
    #
    # List the workspaces associated with a Watson Assistant service instance.
    #
    #   This operation is limited to 500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    headers = {
    }
    params = {
      "version" => @version,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces"
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_workspace(name: nil, description: nil, language: nil, intents: nil, entities: nil, dialog_nodes: nil, counterexamples: nil, metadata: nil, learning_opt_out: nil)
    # Create workspace
    #
    # Create a workspace based on component objects. You must provide workspace
    #   components defining the content of the new workspace.
    #
    #   This operation is limited to 30 requests per 30 minutes. For more information, see
    #   **Rate limiting**.
    #
    # :param String name: The name of the workspace. This string cannot contain carriage return, newline, or
    #   tab characters, and it must be no longer than 64 characters.
    # :param String description: The description of the workspace. This string cannot contain carriage return,
    #   newline, or tab characters, and it must be no longer than 128 characters.
    # :param String language: The language of the workspace.
    # :param list[CreateIntent] intents: An array of objects defining the intents for the workspace.
    # :param list[CreateEntity] entities: An array of objects defining the entities for the workspace.
    # :param list[CreateDialogNode] dialog_nodes: An array of objects defining the nodes in the workspace dialog.
    # :param list[CreateCounterexample] counterexamples: An array of objects defining input examples that have been marked as irrelevant
    #   input.
    # :param Object metadata: Any metadata related to the workspace.
    # :param Boolean learning_opt_out: Whether training data from the workspace can be used by IBM for general service
    #   improvements. `true` indicates that workspace training data is not to be used.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "name" => name,
      "description" => description,
      "language" => language,
      "intents" => intents,
      "entities" => entities,
      "dialog_nodes" => dialog_nodes,
      "counterexamples" => counterexamples,
      "metadata" => metadata,
      "learning_opt_out" => learning_opt_out
    }
    url = "v1/workspaces"
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_workspace(workspace_id:, export: nil, include_audit: nil)
    # Get information about a workspace
    #
    # Get information about a workspace, optionally including all workspace content.
    #
    #   With **export**=`false`, this operation is limited to 6000 requests per 5 minutes.
    #   With **export**=`true`, the limit is 20 requests per 30 minutes. For more
    #   information, see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param Boolean export: Whether to include all element content in the returned data. If
    #   **export**=`false`, the returned data includes only information about the element
    #   itself. If **export**=`true`, all content, including subelements, is included.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "export" => export,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s" % [CGI.escape(workspace_id)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_workspace(workspace_id:, name: nil, description: nil, language: nil, intents: nil, entities: nil, dialog_nodes: nil, counterexamples: nil, metadata: nil, learning_opt_out: nil, append: nil)
    # Update workspace
    #
    # Update an existing workspace with new or modified data. You must provide
    #   component objects defining the content of the updated workspace.
    #
    #   This operation is limited to 30 request per 30 minutes. For more information, see
    #   **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String name: The name of the workspace. This string cannot contain carriage return, newline, or
    #   tab characters, and it must be no longer than 64 characters.
    # :param String description: The description of the workspace. This string cannot contain carriage return,
    #   newline, or tab characters, and it must be no longer than 128 characters.
    # :param String language: The language of the workspace.
    # :param list[CreateIntent] intents: An array of objects defining the intents for the workspace.
    # :param list[CreateEntity] entities: An array of objects defining the entities for the workspace.
    # :param list[CreateDialogNode] dialog_nodes: An array of objects defining the nodes in the workspace dialog.
    # :param list[CreateCounterexample] counterexamples: An array of objects defining input examples that have been marked as irrelevant
    #   input.
    # :param Object metadata: Any metadata related to the workspace.
    # :param Boolean learning_opt_out: Whether training data from the workspace can be used by IBM for general service
    #   improvements. `true` indicates that workspace training data is not to be used.
    # :param Boolean append: Whether the new data is to be appended to the existing data in the workspace. If
    #   **append**=`false`, elements included in the new data completely replace the
    #   corresponding existing elements, including all subelements. For example, if the
    #   new data includes **entities** and **append**=`false`, all existing entities in
    #   the workspace are discarded and replaced with the new entities.
    #
    #   If **append**=`true`, existing elements are preserved, and the new elements are
    #   added. If any elements in the new data collide with existing elements, the update
    #   request fails.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "append" => append
    }
    data = {
      "name" => name,
      "description" => description,
      "language" => language,
      "intents" => intents,
      "entities" => entities,
      "dialog_nodes" => dialog_nodes,
      "counterexamples" => counterexamples,
      "metadata" => metadata,
      "learning_opt_out" => learning_opt_out
    }
    url = "v1/workspaces/%s" % [CGI.escape(workspace_id)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_workspace(workspace_id:)
    # Delete workspace
    #
    # Delete a workspace from the service instance.
    #
    #   This operation is limited to 30 requests per 30 minutes. For more information, see
    #   **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s" % [CGI.escape(workspace_id)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Intents
  #########################

  def list_intents(workspace_id:, export: nil, page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List intents
    #
    # List the intents for a workspace.
    #
    #   With **export**=`false`, this operation is limited to 2000 requests per 30
    #   minutes. With **export**=`true`, the limit is 400 requests per 30 minutes. For
    #   more information, see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param Boolean export: Whether to include all element content in the returned data. If
    #   **export**=`false`, the returned data includes only information about the element
    #   itself. If **export**=`true`, all content, including subelements, is included.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "export" => export,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/intents" % [CGI.escape(workspace_id)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_intent(workspace_id:, intent:, description: nil, examples: nil)
    # Create intent
    #
    # Create a new intent.
    #
    #   This operation is limited to 2000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The name of the intent. This string must conform to the following restrictions:
    #   - It can contain only Unicode alphanumeric, underscore, hyphen, and dot
    #   characters.
    #   - It cannot begin with the reserved prefix `sys-`.
    #   - It must be no longer than 128 characters.
    # :param String description: The description of the intent. This string cannot contain carriage return,
    #   newline, or tab characters, and it must be no longer than 128 characters.
    # :param list[CreateExample] examples: An array of user input examples for the intent.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "intent" => intent,
      "description" => description,
      "examples" => examples
    }
    url = "v1/workspaces/%s/intents" % [CGI.escape(workspace_id)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_intent(workspace_id:, intent:, export: nil, include_audit: nil)
    # Get intent
    #
    # Get information about an intent, optionally including all intent content.
    #
    #   With **export**=`false`, this operation is limited to 6000 requests per 5 minutes.
    #   With **export**=`true`, the limit is 400 requests per 30 minutes. For more
    #   information, see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param Boolean export: Whether to include all element content in the returned data. If
    #   **export**=`false`, the returned data includes only information about the element
    #   itself. If **export**=`true`, all content, including subelements, is included.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "export" => export,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/intents/%s" % [CGI.escape(workspace_id), CGI.escape(intent)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_intent(workspace_id:, intent:, new_intent: nil, new_description: nil, new_examples: nil)
    # Update intent
    #
    # Update an existing intent with new or modified data. You must provide component
    #   objects defining the content of the updated intent.
    #
    #   This operation is limited to 2000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param String new_intent: The name of the intent. This string must conform to the following restrictions:
    #   - It can contain only Unicode alphanumeric, underscore, hyphen, and dot
    #   characters.
    #   - It cannot begin with the reserved prefix `sys-`.
    #   - It must be no longer than 128 characters.
    # :param String new_description: The description of the intent.
    # :param list[CreateExample] new_examples: An array of user input examples for the intent.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "intent" => new_intent,
      "description" => new_description,
      "examples" => new_examples
    }
    url = "v1/workspaces/%s/intents/%s" % [CGI.escape(workspace_id), CGI.escape(intent)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_intent(workspace_id:, intent:)
    # Delete intent
    #
    # Delete an intent from a workspace.
    #
    #   This operation is limited to 2000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s/intents/%s" % [CGI.escape(workspace_id), CGI.escape(intent)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Examples
  #########################

  def list_examples(workspace_id:, intent:, page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List user input examples
    #
    # List the user input examples for an intent.
    #
    #   This operation is limited to 2500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/intents/%s/examples" % [CGI.escape(workspace_id), CGI.escape(intent)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_example(workspace_id:, intent:, text:)
    # Create user input example
    #
    # Add a new user input example to an intent.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param String text: The text of a user input example. This string must conform to the following
    #   restrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 1024 characters.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "text" => text
    }
    url = "v1/workspaces/%s/intents/%s/examples" % [CGI.escape(workspace_id), CGI.escape(intent)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_example(workspace_id:, intent:, text:, include_audit: nil)
    # Get user input example
    #
    # Get information about a user input example.
    #
    #   This operation is limited to 6000 requests per 5 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param String text: The text of the user input example.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/intents/%s/examples/%s" % [CGI.escape(workspace_id), CGI.escape(intent), CGI.escape(text)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_example(workspace_id:, intent:, text:, new_text: nil)
    # Update user input example
    #
    # Update the text of a user input example.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param String text: The text of the user input example.
    # :param String new_text: The text of the user input example. This string must conform to the following
    #   restrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 1024 characters.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "text" => new_text
    }
    url = "v1/workspaces/%s/intents/%s/examples/%s" % [CGI.escape(workspace_id), CGI.escape(intent), CGI.escape(text)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_example(workspace_id:, intent:, text:)
    # Delete user input example
    #
    # Delete a user input example from an intent.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String intent: The intent name.
    # :param String text: The text of the user input example.
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("intent must be provided") if intent.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s/intents/%s/examples/%s" % [CGI.escape(workspace_id), CGI.escape(intent), CGI.escape(text)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Counterexamples
  #########################

  def list_counterexamples(workspace_id:, page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List counterexamples
    #
    # List the counterexamples for a workspace. Counterexamples are examples that have
    #   been marked as irrelevant input.
    #
    #   This operation is limited to 2500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/counterexamples" % [CGI.escape(workspace_id)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_counterexample(workspace_id:, text:)
    # Create counterexample
    #
    # Add a new counterexample to a workspace. Counterexamples are examples that have
    #   been marked as irrelevant input.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String text: The text of a user input marked as irrelevant input. This string must conform to
    #   the following restrictions:
    #   - It cannot contain carriage return, newline, or tab characters
    #   - It cannot consist of only whitespace characters
    #   - It must be no longer than 1024 characters.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "text" => text
    }
    url = "v1/workspaces/%s/counterexamples" % [CGI.escape(workspace_id)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_counterexample(workspace_id:, text:, include_audit: nil)
    # Get counterexample
    #
    # Get information about a counterexample. Counterexamples are examples that have
    #   been marked as irrelevant input.
    #
    #   This operation is limited to 6000 requests per 5 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String text: The text of a user input counterexample (for example, `What are you wearing?`).
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/counterexamples/%s" % [CGI.escape(workspace_id), CGI.escape(text)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_counterexample(workspace_id:, text:, new_text: nil)
    # Update counterexample
    #
    # Update the text of a counterexample. Counterexamples are examples that have been
    #   marked as irrelevant input.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String text: The text of a user input counterexample (for example, `What are you wearing?`).
    # :param String new_text: The text of a user input counterexample.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "text" => new_text
    }
    url = "v1/workspaces/%s/counterexamples/%s" % [CGI.escape(workspace_id), CGI.escape(text)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_counterexample(workspace_id:, text:)
    # Delete counterexample
    #
    # Delete a counterexample from a workspace. Counterexamples are examples that have
    #   been marked as irrelevant input.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String text: The text of a user input counterexample (for example, `What are you wearing?`).
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("text must be provided") if text.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s/counterexamples/%s" % [CGI.escape(workspace_id), CGI.escape(text)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Entities
  #########################

  def list_entities(workspace_id:, export: nil, page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List entities
    #
    # List the entities for a workspace.
    #
    #   With **export**=`false`, this operation is limited to 1000 requests per 30
    #   minutes. With **export**=`true`, the limit is 200 requests per 30 minutes. For
    #   more information, see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param Boolean export: Whether to include all element content in the returned data. If
    #   **export**=`false`, the returned data includes only information about the element
    #   itself. If **export**=`true`, all content, including subelements, is included.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "export" => export,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/entities" % [CGI.escape(workspace_id)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_entity(workspace_id:, entity:, description: nil, metadata: nil, values: nil, fuzzy_match: nil)
    # Create entity
    #
    # Create a new entity.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity. This string must conform to the following restrictions:
    #   - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
    #   - It cannot begin with the reserved prefix `sys-`.
    #   - It must be no longer than 64 characters.
    # :param String description: The description of the entity. This string cannot contain carriage return,
    #   newline, or tab characters, and it must be no longer than 128 characters.
    # :param Object metadata: Any metadata related to the value.
    # :param list[CreateValue] values: An array of objects describing the entity values.
    # :param Boolean fuzzy_match: Whether to use fuzzy matching for the entity.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "entity" => entity,
      "description" => description,
      "metadata" => metadata,
      "values" => values,
      "fuzzy_match" => fuzzy_match
    }
    url = "v1/workspaces/%s/entities" % [CGI.escape(workspace_id)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_entity(workspace_id:, entity:, export: nil, include_audit: nil)
    # Get entity
    #
    # Get information about an entity, optionally including all entity content.
    #
    #   With **export**=`false`, this operation is limited to 6000 requests per 5 minutes.
    #   With **export**=`true`, the limit is 200 requests per 30 minutes. For more
    #   information, see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param Boolean export: Whether to include all element content in the returned data. If
    #   **export**=`false`, the returned data includes only information about the element
    #   itself. If **export**=`true`, all content, including subelements, is included.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "export" => export,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/entities/%s" % [CGI.escape(workspace_id), CGI.escape(entity)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_entity(workspace_id:, entity:, new_entity: nil, new_description: nil, new_metadata: nil, new_fuzzy_match: nil, new_values: nil)
    # Update entity
    #
    # Update an existing entity with new or modified data. You must provide component
    #   objects defining the content of the updated entity.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String new_entity: The name of the entity. This string must conform to the following restrictions:
    #   - It can contain only Unicode alphanumeric, underscore, and hyphen characters.
    #   - It cannot begin with the reserved prefix `sys-`.
    #   - It must be no longer than 64 characters.
    # :param String new_description: The description of the entity. This string cannot contain carriage return,
    #   newline, or tab characters, and it must be no longer than 128 characters.
    # :param Object new_metadata: Any metadata related to the entity.
    # :param Boolean new_fuzzy_match: Whether to use fuzzy matching for the entity.
    # :param list[CreateValue] new_values: An array of entity values.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "entity" => new_entity,
      "description" => new_description,
      "metadata" => new_metadata,
      "fuzzy_match" => new_fuzzy_match,
      "values" => new_values
    }
    url = "v1/workspaces/%s/entities/%s" % [CGI.escape(workspace_id), CGI.escape(entity)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_entity(workspace_id:, entity:)
    # Delete entity
    #
    # Delete an entity from a workspace.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s/entities/%s" % [CGI.escape(workspace_id), CGI.escape(entity)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Values
  #########################

  def list_values(workspace_id:, entity:, export: nil, page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List entity values
    #
    # List the values for an entity.
    #
    #   This operation is limited to 2500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param Boolean export: Whether to include all element content in the returned data. If
    #   **export**=`false`, the returned data includes only information about the element
    #   itself. If **export**=`true`, all content, including subelements, is included.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "export" => export,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/entities/%s/values" % [CGI.escape(workspace_id), CGI.escape(entity)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_value(workspace_id:, entity:, value:, metadata: nil, synonyms: nil, patterns: nil, value_type: nil)
    # Add entity value
    #
    # Create a new value for an entity.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value. This string must conform to the following
    #   restrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 64 characters.
    # :param Object metadata: Any metadata related to the entity value.
    # :param list[String] synonyms: An array containing any synonyms for the entity value. You can provide either
    #   synonyms or patterns (as indicated by **type**), but not both. A synonym must
    #   conform to the following restrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 64 characters.
    # :param list[String] patterns: An array of patterns for the entity value. You can provide either synonyms or
    #   patterns (as indicated by **type**), but not both. A pattern is a regular
    #   expression no longer than 128 characters. For more information about how to
    #   specify a pattern, see the
    #   [documentation](https://console.bluemix.net/docs/services/conversation/entities.html#creating-entities).
    # :param String value_type: Specifies the type of value.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "value" => value,
      "metadata" => metadata,
      "synonyms" => synonyms,
      "patterns" => patterns,
      "type" => value_type
    }
    url = "v1/workspaces/%s/entities/%s/values" % [CGI.escape(workspace_id), CGI.escape(entity)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_value(workspace_id:, entity:, value:, export: nil, include_audit: nil)
    # Get entity value
    #
    # Get information about an entity value.
    #
    #   This operation is limited to 6000 requests per 5 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param Boolean export: Whether to include all element content in the returned data. If
    #   **export**=`false`, the returned data includes only information about the element
    #   itself. If **export**=`true`, all content, including subelements, is included.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "export" => export,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/entities/%s/values/%s" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_value(workspace_id:, entity:, value:, new_value: nil, new_metadata: nil, new_type: nil, new_synonyms: nil, new_patterns: nil)
    # Update entity value
    #
    # Update an existing entity value with new or modified data. You must provide
    #   component objects defining the content of the updated entity value.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param String new_value: The text of the entity value. This string must conform to the following
    #   restrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 64 characters.
    # :param Object new_metadata: Any metadata related to the entity value.
    # :param String new_type: Specifies the type of value.
    # :param list[String] new_synonyms: An array of synonyms for the entity value. You can provide either synonyms or
    #   patterns (as indicated by **type**), but not both. A synonym must conform to the
    #   following resrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 64 characters.
    # :param list[String] new_patterns: An array of patterns for the entity value. You can provide either synonyms or
    #   patterns (as indicated by **type**), but not both. A pattern is a regular
    #   expression no longer than 128 characters. For more information about how to
    #   specify a pattern, see the
    #   [documentation](https://console.bluemix.net/docs/services/conversation/entities.html#creating-entities).
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "value" => new_value,
      "metadata" => new_metadata,
      "type" => new_type,
      "synonyms" => new_synonyms,
      "patterns" => new_patterns
    }
    url = "v1/workspaces/%s/entities/%s/values/%s" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_value(workspace_id:, entity:, value:)
    # Delete entity value
    #
    # Delete a value from an entity.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s/entities/%s/values/%s" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Synonyms
  #########################

  def list_synonyms(workspace_id:, entity:, value:, page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List entity value synonyms
    #
    # List the synonyms for an entity value.
    #
    #   This operation is limited to 2500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/entities/%s/values/%s/synonyms" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_synonym(workspace_id:, entity:, value:, synonym:)
    # Add entity value synonym
    #
    # Add a new synonym to an entity value.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param String synonym: The text of the synonym. This string must conform to the following restrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 64 characters.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    raise ArgumentError("synonym must be provided") if synonym.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "synonym" => synonym
    }
    url = "v1/workspaces/%s/entities/%s/values/%s/synonyms" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_synonym(workspace_id:, entity:, value:, synonym:, include_audit: nil)
    # Get entity value synonym
    #
    # Get information about a synonym of an entity value.
    #
    #   This operation is limited to 6000 requests per 5 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param String synonym: The text of the synonym.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    raise ArgumentError("synonym must be provided") if synonym.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/entities/%s/values/%s/synonyms/%s" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value), CGI.escape(synonym)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_synonym(workspace_id:, entity:, value:, synonym:, new_synonym: nil)
    # Update entity value synonym
    #
    # Update an existing entity value synonym with new text.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param String synonym: The text of the synonym.
    # :param String new_synonym: The text of the synonym. This string must conform to the following restrictions:
    #   - It cannot contain carriage return, newline, or tab characters.
    #   - It cannot consist of only whitespace characters.
    #   - It must be no longer than 64 characters.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    raise ArgumentError("synonym must be provided") if synonym.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "synonym" => new_synonym
    }
    url = "v1/workspaces/%s/entities/%s/values/%s/synonyms/%s" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value), CGI.escape(synonym)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_synonym(workspace_id:, entity:, value:, synonym:)
    # Delete entity value synonym
    #
    # Delete a synonym from an entity value.
    #
    #   This operation is limited to 1000 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String entity: The name of the entity.
    # :param String value: The text of the entity value.
    # :param String synonym: The text of the synonym.
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("entity must be provided") if entity.nil?
    raise ArgumentError("value must be provided") if value.nil?
    raise ArgumentError("synonym must be provided") if synonym.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s/entities/%s/values/%s/synonyms/%s" % [CGI.escape(workspace_id), CGI.escape(entity), CGI.escape(value), CGI.escape(synonym)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Dialog nodes
  #########################

  def list_dialog_nodes(workspace_id:, page_limit: nil, include_count: nil, sort: nil, cursor: nil, include_audit: nil)
    # List dialog nodes
    #
    # List the dialog nodes for a workspace.
    #
    #   This operation is limited to 2500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param Boolean include_count: Whether to include information about the number of records returned.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "page_limit" => page_limit,
      "include_count" => include_count,
      "sort" => sort,
      "cursor" => cursor,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/dialog_nodes" % [CGI.escape(workspace_id)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def create_dialog_node(workspace_id:, dialog_node:, description: nil, conditions: nil, parent: nil, previous_sibling: nil, output: nil, context: nil, metadata: nil, next_step: nil, actions: nil, title: nil, node_type: nil, event_name: nil, variable: nil, digress_in: nil, digress_out: nil, digress_out_slots: nil)
    # Create dialog node
    #
    # Create a new dialog node.
    #
    #   This operation is limited to 500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String dialog_node: The dialog node ID. This string must conform to the following restrictions:
    #   - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot
    #   characters.
    #   - It must be no longer than 1024 characters.
    # :param String description: The description of the dialog node. This string cannot contain carriage return,
    #   newline, or tab characters, and it must be no longer than 128 characters.
    # :param String conditions: The condition that will trigger the dialog node. This string cannot contain
    #   carriage return, newline, or tab characters, and it must be no longer than 2048
    #   characters.
    # :param String parent: The ID of the parent dialog node.
    # :param String previous_sibling: The ID of the previous dialog node.
    # :param Object output: The output of the dialog node. For more information about how to specify dialog
    #   node output, see the
    #   [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).
    # :param Object context: The context for the dialog node.
    # :param Object metadata: The metadata for the dialog node.
    # :param DialogNodeNextStep next_step: The next step to be executed in dialog processing.
    # :param list[DialogNodeAction] actions: An array of objects describing any actions to be invoked by the dialog node.
    # :param String title: The alias used to identify the dialog node. This string must conform to the
    #   following restrictions:
    #   - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot
    #   characters.
    #   - It must be no longer than 64 characters.
    # :param String node_type: How the dialog node is processed.
    # :param String event_name: How an `event_handler` node is processed.
    # :param String variable: The location in the dialog context where output is stored.
    # :param String digress_in: Whether this top-level dialog node can be digressed into.
    # :param String digress_out: Whether this dialog node can be returned to after a digression.
    # :param String digress_out_slots: Whether the user can digress to top-level nodes while filling out slots.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("dialog_node must be provided") if dialog_node.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "dialog_node" => dialog_node,
      "description" => description,
      "conditions" => conditions,
      "parent" => parent,
      "previous_sibling" => previous_sibling,
      "output" => output,
      "context" => context,
      "metadata" => metadata,
      "next_step" => next_step,
      "actions" => actions,
      "title" => title,
      "type" => node_type,
      "event_name" => event_name,
      "variable" => variable,
      "digress_in" => digress_in,
      "digress_out" => digress_out,
      "digress_out_slots" => digress_out_slots
    }
    url = "v1/workspaces/%s/dialog_nodes" % [CGI.escape(workspace_id)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def get_dialog_node(workspace_id:, dialog_node:, include_audit: nil)
    # Get dialog node
    #
    # Get information about a dialog node.
    #
    #   This operation is limited to 6000 requests per 5 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String dialog_node: The dialog node ID (for example, `get_order`).
    # :param Boolean include_audit: Whether to include the audit properties (`created` and `updated` timestamps) in
    #   the response.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("dialog_node must be provided") if dialog_node.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "include_audit" => include_audit
    }
    url = "v1/workspaces/%s/dialog_nodes/%s" % [CGI.escape(workspace_id), CGI.escape(dialog_node)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def update_dialog_node(workspace_id:, dialog_node:, new_dialog_node: nil, new_description: nil, new_conditions: nil, new_parent: nil, new_previous_sibling: nil, new_output: nil, new_context: nil, new_metadata: nil, new_next_step: nil, new_title: nil, new_type: nil, new_event_name: nil, new_variable: nil, new_actions: nil, new_digress_in: nil, new_digress_out: nil, new_digress_out_slots: nil)
    # Update dialog node
    #
    # Update an existing dialog node with new or modified data.
    #
    #   This operation is limited to 500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String dialog_node: The dialog node ID (for example, `get_order`).
    # :param String new_dialog_node: The dialog node ID. This string must conform to the following restrictions:
    #   - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot
    #   characters.
    #   - It must be no longer than 1024 characters.
    # :param String new_description: The description of the dialog node. This string cannot contain carriage return,
    #   newline, or tab characters, and it must be no longer than 128 characters.
    # :param String new_conditions: The condition that will trigger the dialog node. This string cannot contain
    #   carriage return, newline, or tab characters, and it must be no longer than 2048
    #   characters.
    # :param String new_parent: The ID of the parent dialog node.
    # :param String new_previous_sibling: The ID of the previous sibling dialog node.
    # :param Object new_output: The output of the dialog node. For more information about how to specify dialog
    #   node output, see the
    #   [documentation](https://console.bluemix.net/docs/services/conversation/dialog-overview.html#complex).
    # :param Object new_context: The context for the dialog node.
    # :param Object new_metadata: The metadata for the dialog node.
    # :param DialogNodeNextStep new_next_step: The next step to be executed in dialog processing.
    # :param String new_title: The alias used to identify the dialog node. This string must conform to the
    #   following restrictions:
    #   - It can contain only Unicode alphanumeric, space, underscore, hyphen, and dot
    #   characters.
    #   - It must be no longer than 64 characters.
    # :param String new_type: How the dialog node is processed.
    # :param String new_event_name: How an `event_handler` node is processed.
    # :param String new_variable: The location in the dialog context where output is stored.
    # :param list[DialogNodeAction] new_actions: An array of objects describing any actions to be invoked by the dialog node.
    # :param String new_digress_in: Whether this top-level dialog node can be digressed into.
    # :param String new_digress_out: Whether this dialog node can be returned to after a digression.
    # :param String new_digress_out_slots: Whether the user can digress to top-level nodes while filling out slots.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("dialog_node must be provided") if dialog_node.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    data = {
      "dialog_node" => new_dialog_node,
      "description" => new_description,
      "conditions" => new_conditions,
      "parent" => new_parent,
      "previous_sibling" => new_previous_sibling,
      "output" => new_output,
      "context" => new_context,
      "metadata" => new_metadata,
      "next_step" => new_next_step,
      "title" => new_title,
      "type" => new_type,
      "event_name" => new_event_name,
      "variable" => new_variable,
      "actions" => new_actions,
      "digress_in" => new_digress_in,
      "digress_out" => new_digress_out,
      "digress_out_slots" => new_digress_out_slots
    }
    url = "v1/workspaces/%s/dialog_nodes/%s" % [CGI.escape(workspace_id), CGI.escape(dialog_node)]
    response = request(
      method: "POST",
      url: url,
      headers: headers,
      params: params,
      json: data,
      accept_json: true
    )
    response
  end

  def delete_dialog_node(workspace_id:, dialog_node:)
    # Delete dialog node
    #
    # Delete a dialog node from a workspace.
    #
    #   This operation is limited to 500 requests per 30 minutes. For more information,
    #   see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String dialog_node: The dialog node ID (for example, `get_order`).
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    raise ArgumentError("dialog_node must be provided") if dialog_node.nil?
    headers = {
    }
    params = {
      "version" => @version
    }
    url = "v1/workspaces/%s/dialog_nodes/%s" % [CGI.escape(workspace_id), CGI.escape(dialog_node)]
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

  #########################
  # Logs
  #########################

  def list_logs(workspace_id:, sort: nil, filter: nil, page_limit: nil, cursor: nil)
    # List log events in a workspace
    #
    # List the events from the log of a specific workspace.
    #
    #   If **cursor** is not specified, this operation is limited to 40 requests per 30
    #   minutes. If **cursor** is specified, the limit is 120 requests per minute. For
    #   more information, see **Rate limiting**.
    #
    # :param String workspace_id: Unique identifier of the workspace.
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param String filter: A cacheable parameter that limits the results to those matching the specified
    #   filter. For more information, see the
    #   [documentation](https://console.bluemix.net/docs/services/conversation/filter-reference.html#filter-query-syntax).
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("workspace_id must be provided") if workspace_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "sort" => sort,
      "filter" => filter,
      "page_limit" => page_limit,
      "cursor" => cursor
    }
    url = "v1/workspaces/%s/logs" % [CGI.escape(workspace_id)]
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  def list_all_logs(filter:, sort: nil, page_limit: nil, cursor: nil)
    # List log events in all workspaces
    #
    # List the events from the logs of all workspaces in the service instance.
    #
    #   If **cursor** is not specified, this operation is limited to 40 requests per 30
    #   minutes. If **cursor** is specified, the limit is 120 requests per minute. For
    #   more information, see **Rate limiting**.
    #
    # :param String filter: A cacheable parameter that limits the results to those matching the specified
    #   filter. You must specify a filter query that includes a value for `language`, as
    #   well as a value for `workspace_id` or `request.context.metadata.deployment`. For
    #   more information, see the
    #   [documentation](https://console.bluemix.net/docs/services/conversation/filter-reference.html#filter-query-syntax).
    # :param String sort: The attribute by which returned results will be sorted. To reverse the sort order,
    #   prefix the value with a minus sign (`-`). Supported values are `name`, `updated`,
    #   and `workspace_id`.
    # :param Fixnum page_limit: The number of records to return in each page of results.
    # :param String cursor: A token identifying the page of results to retrieve.
    # :param Hash headers: A `Hash` containing the request headers
    # :return: A `DetailedResponse` object representing the response.
    # :rtype: DetailedResponse
    raise ArgumentError("filter must be provided") if filter.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "filter" => filter,
      "sort" => sort,
      "page_limit" => page_limit,
      "cursor" => cursor
    }
    url = "v1/logs"
    response = request(
      method: "GET",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    response
  end

  #########################
  # User data
  #########################

  def delete_user_data(customer_id:)
    # Delete labeled data
    #
    # Deletes all data associated with a specified customer ID. The method has no
    #   effect if no data is associated with the customer ID.
    #
    #   You associate a customer ID with data by passing the `X-Watson-Metadata` header
    #   with a request that passes data. For more information about personal data and
    #   customer IDs, see [Information
    #   security](https://console.bluemix.net/docs/services/conversation/information-security.html).
    #
    # :param String customer_id: The customer ID for which all data is to be deleted.
    # :param Hash headers: A `Hash` containing the request headers
    # :rtype: nil
    raise ArgumentError("customer_id must be provided") if customer_id.nil?
    headers = {
    }
    params = {
      "version" => @version,
      "customer_id" => customer_id
    }
    url = "v1/user_data"
    request(
      method: "DELETE",
      url: url,
      headers: headers,
      params: params,
      accept_json: true
    )
    nil
  end

end