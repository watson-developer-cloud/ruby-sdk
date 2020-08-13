# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")
SimpleCov.command_name "test:unit"

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Watson Assistant V1 Service
class AssistantV2Test < Minitest::Test
  include Minitest::Hooks
  attr_accessor :service
  def before_all
    authenticator = IBMWatson::Authenticators::NoAuthAuthenticator.new
    @service = IBMWatson::AssistantV2.new(
      version: "2018-02-16",
      authenticator: authenticator
    )
  end

  def test_message
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    assistant_id = "f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec"
    session_id = "session"
    message_response = {
      "context" => {
        "conversation_id" => "1b7b67c0-90ed-45dc-8508-9488bc483d5b",
        "system" => {
          "dialog_stack" => ["root"],
          "dialog_turn_counter" => 1,
          "dialog_request_counter" => 1
        }
      },
      "intents" => [],
      "entities" => [],
      "input" => {},
      "output" => {
        "text" => "okay",
        "log_messages" => []
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v2/assistants/f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec/sessions/session/message?version=2018-02-16")
      .with(
        body: "{\"input\":{\"text\":\"Turn on the lights\"}}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)
    service_response = service.message(
      assistant_id: assistant_id,
      session_id: session_id,
      input: { "text" => "Turn on the lights" },
      context: nil
    )
    assert_equal(message_response, service_response.result)

    message_ctx = {
      "context" => {
        "conversation_id" => "1b7b67c0-90ed-45dc-8508-9488bc483d5b",
        "system" => {
          "dialog_stack" => ["root"],
          "dialog_turn_counter" => 2,
          "dialog_request_counter" => 1
        }
      }
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v2/assistants/f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec/sessions/session/message?version=2018-02-16")
      .with(
        body: "{\"input\":{\"text\":\"Turn on the lights\"},\"context\":\"{\\\"conversation_id\\\":\\\"1b7b67c0-90ed-45dc-8508-9488bc483d5b\\\",\\\"system\\\":{\\\"dialog_stack\\\":[\\\"root\\\"],\\\"dialog_turn_counter\\\":2,\\\"dialog_request_counter\\\":1}}\"}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)
    service_response = service.message(
      assistant_id: assistant_id,
      session_id: session_id,
      input: { "text" => "Turn on the lights" },
      context: message_ctx["context"].to_json
    )
    assert_equal(message_response, service_response.result)
  end

  def test_create_session
    # response = {
    #   "name" => "Pizza app",
    #   "created" => "2015-12-06T23:53:59.153Z",
    #   "language" => "en",
    #   "metadata" => {},
    #   "updated" => "2015-12-06T23:53:59.153Z",
    #   "description" => "Pizza app",
    #   "assistant_id" => "pizza_app-e0f3"
    # }
    # headers = {
    #   "Content-Type" => "application/json"
    # }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v2/assistants/pizza_app-e0f3/sessions?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.create_session(
      assistant_id: "pizza_app-e0f3"
    )
    assert_equal("", service_response.result)
  end

  def test_delete_session
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v2/assistants/pizza_app-e0f3/sessions/session?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_session(
      assistant_id: "pizza_app-e0f3",
      session_id: "session"
    )
    assert_nil(service_response)
  end

  def test_message_stateless
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    assistant_id = "f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec"
    message_response = {
      "context" => {
        "conversation_id" => "1b7b67c0-90ed-45dc-8508-9488bc483d5b",
        "system" => {
          "dialog_stack" => ["root"],
          "dialog_turn_counter" => 1,
          "dialog_request_counter" => 1
        }
      },
      "intents" => [],
      "entities" => [],
      "input" => {},
      "output" => {
        "text" => "okay",
        "log_messages" => []
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v2/assistants/f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec/message?version=2018-02-16")
      .with(
        body: "{\"input\":{\"text\":\"Turn on the lights\"}}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)
    service_response = service.message_stateless(
      assistant_id: assistant_id,
      input: { "text" => "Turn on the lights" },
      context: nil
    )
    assert_equal(message_response, service_response.result)

    message_ctx = {
      "context" => {
        "conversation_id" => "1b7b67c0-90ed-45dc-8508-9488bc483d5b",
        "system" => {
          "dialog_stack" => ["root"],
          "dialog_turn_counter" => 2,
          "dialog_request_counter" => 1
        }
      }
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v2/assistants/f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec/message?version=2018-02-16")
      .with(
        body: "{\"input\":{\"text\":\"Turn on the lights\"},\"context\":\"{\\\"conversation_id\\\":\\\"1b7b67c0-90ed-45dc-8508-9488bc483d5b\\\",\\\"system\\\":{\\\"dialog_stack\\\":[\\\"root\\\"],\\\"dialog_turn_counter\\\":2,\\\"dialog_request_counter\\\":1}}\"}",
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)
    service_response = service.message_stateless(
      assistant_id: assistant_id,
      input: { "text" => "Turn on the lights" },
      context: message_ctx["context"].to_json
    )
    assert_equal(message_response, service_response.result)
  end

  def test_list_logs
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v2/assistants/pizza_app-e0f3/logs?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.list_logs(
      assistant_id: "pizza_app-e0f3"
    )
    assert_equal("", service_response.result)
  end

  def test_delete_user_data
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v2/user_data?customer_id=pizza_app-e0f3&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_user_data(
      customer_id: "pizza_app-e0f3"
    )
    assert_nil(service_response)
  end
end
