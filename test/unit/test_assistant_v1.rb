# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")
SimpleCov.command_name "test:unit"

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Watson Assistant V1 Service
class AssistantV1Test < Minitest::Test
  def test_plain_to_json
    response = {
      "text" => "I want financial advice today.",
      "created" => "2016-07-11T16:39:01.774Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples?version=2018-02-16")
      .with(
        body: "{\"text\":\"I want financial advice today.\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 201, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      version: "2018-02-16",
      username: "username",
      password: "password"
    )
    service_response = service.create_counterexample(
      workspace_id: "boguswid",
      text: "I want financial advice today."
    )
    assert_equal(response, service_response.body)
  end

  def test_rate_limit_exceeded
    error_code = 429
    error_msg = "Rate limit exceeded"
    headers = {
      "Content-Type" => "application/json"
    }
    error_response = {
      "code" => error_code,
      "error" => error_msg
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples?version=2018-02-16")
      .with(
        body: "{\"text\":\"I want financial advice today.\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 429, body: error_response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    begin
      service.create_counterexample(
        workspace_id: "boguswid",
        text: "I want financial advice today."
      )
    rescue WatsonApiException => e
      assert_equal(error_code, e.code)
      assert_equal(error_msg, e.error)
      assert(e.to_s.instance_of?(String))
    end
  end

  def test_unknown_error
    error_msg = "Unknown error"
    error_code = 407
    headers = {
      "Content-Type" => "application/json"
    }
    error_response = {
      "error" => error_msg,
      "code" => error_code
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples?version=2018-02-16")
      .with(
        body: "{\"text\":\"I want financial advice today.\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 407, body: error_response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    begin
      service.create_counterexample(
        workspace_id: "boguswid",
        text: "I want financial advice today."
      )
    rescue WatsonApiException => e
      assert_equal(error_code, e.code)
      assert_equal(error_msg, e.error)
    end
  end

  def test_delete_counterexample
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples/I%20want%20financial%20advice%20today?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: {}.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_counterexample(
      workspace_id: "boguswid",
      text: "I want financial advice today"
    )
    assert(service_response.nil?)
  end

  def test_get_counterexample
    response = {
      "text" => "What are you wearing?",
      "created" => "2016-07-11T23:53:59.153Z",
      "updated" => "2016-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples/What%20are%20you%20wearing%3F?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.get_counterexample(
      workspace_id: "boguswid",
      text: "What are you wearing?"
    )
    assert_equal(response, service_response.body)
  end

  def test_list_counterexamples
    response = {
      "counterexamples" => [
        {
          "text" => "I want financial advice today.",
          "created" => "2016-07-11T16:39:01.774Z",
          "updated" => "2015-12-07T18:53:59.153Z"
        }, {
          "text" => "What are you wearing today",
          "created" => "2016-07-11T16:39:01.774Z",
          "updated" => "2015-12-07T18:53:59.153Z"
        }
      ],
      "pagination" => {
        "refresh_url" => "/v1/workspaces/pizza_app-e0f3/counterexamples?version=2017-12-18&page_limit=2",
        "next_url" => "/v1/workspaces/pizza_app-e0f3/counterexamples?cursor=base64=&version=2017-12-18&page_limit=2"
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_counterexamples(
      workspace_id: "boguswid"
    )
    assert_equal(response, service_response.body)
  end

  def test_update_counterexample
    response = {
      "text" => "What are you wearing?",
      "created" => "2016-07-11T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/counterexamples/What%20are%20you%20wearing%3F?version=2018-02-16")
      .with(
        body: "{\"text\":\"What are you wearing?\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.update_counterexample(
      workspace_id: "boguswid",
      text: "What are you wearing?",
      new_text: "What are you wearing?"
    )
    assert_equal(response, service_response.body)
  end

  def test_create_entity
    response = {
      "entity" => "pizza_toppings",
      "description" => "Tasty pizza toppings",
      "created" => "2015-12-06T04:32:20.000Z",
      "updated" => "2015-12-07T18:53:59.153Z",
      "metadata" => {
        "property" => "value"
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities?version=2018-02-16")
      .with(
        body: "{\"entity\":\"pizza_toppings\",\"description\":\"Tasty pizza toppings\",\"metadata\":{\"property\":\"value\"}}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.create_entity(
      workspace_id: "boguswid",
      entity: "pizza_toppings",
      description: "Tasty pizza toppings",
      metadata: { "property" => "value" },
      values: nil,
      fuzzy_match: nil
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_entity
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/pizza_toppings?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "{}", headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_entity(
      workspace_id: "boguswid",
      entity: "pizza_toppings"
    )
    assert(service_response.nil?)
  end

  def test_get_entity
    response = {
      "entity" => "pizza_toppings",
      "description" => "Tasty pizza toppings",
      "created" => "2015-12-06T04:32:20.000Z",
      "updated" => "2015-12-07T18:53:59.153Z",
      "metadata" => {
        "property" => "value"
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/pizza_toppings?export=true&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.get_entity(
      workspace_id: "boguswid",
      entity: "pizza_toppings",
      export: true
    )
    assert_equal(response, service_response.body)
  end

  def test_list_entities
    response = {
      "entities" => [
        {
          "entity" => "pizza_toppings",
          "description" => "Tasty pizza toppings",
          "created" => "2015-12-06T04:32:20.000Z",
          "updated" => "2015-12-07T18:53:59.153Z",
          "metadata" => {
            "property" => "value"
          }
        }
      ],
      "pagination" => {
        "refresh_url" => "/v1/workspaces/pizza_app-e0f3/entities?version=2017-12-18&filter=name:pizza&include_count=true&page_limit=1",
        "next_url" => "/v1/workspaces/pizza_app-e0f3/entities?cursor=base64=&version=2017-12-18&filter=name:pizza&page_limit=1",
        "total" => 1,
        "matched" => 1
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities?export=true&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_entities(
      workspace_id: "boguswid",
      export: true
    )
    assert_equal(response, service_response.body)
  end

  def test_update_entity
    response = {
      "entity" => "pizza_toppings",
      "description" => "Tasty pizza toppings",
      "created" => "2015-12-06T04:32:20.000Z",
      "updated" => "2015-12-07T18:53:59.153Z",
      "metadata" => {
        "property" => "value"
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/pizza_toppings?version=2018-02-16")
      .with(
        body: "{\"entity\":\"pizza_toppings\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.update_entity(
      workspace_id: "boguswid",
      entity: "pizza_toppings",
      new_entity: "pizza_toppings"
    )
    assert_equal(response, service_response.body)
  end

  def test_create_example
    response = {
      "text" => "Gimme a pizza with pepperoni",
      "created" => "2016-07-11T16:39:01.774Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order/examples?version=2018-02-16")
      .with(
        body: "{\"text\":\"Gimme a pizza with pepperoni\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 201, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.create_example(
      workspace_id: "boguswid",
      intent: "pizza_order",
      text: "Gimme a pizza with pepperoni"
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_example
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order/examples/Gimme%20a%20pizza%20with%20pepperoni?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "{}", headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_example(
      workspace_id: "boguswid",
      intent: "pizza_order",
      text: "Gimme a pizza with pepperoni"
    )
    assert(service_response.nil?)
  end

  def test_get_example
    response = {
      "text" => "Gimme a pizza with pepperoni",
      "created" => "2016-07-11T23:53:59.153Z",
      "updated" => "2016-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order/examples/Gimme%20a%20pizza%20with%20pepperoni?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.get_example(
      workspace_id: "boguswid",
      intent: "pizza_order",
      text: "Gimme a pizza with pepperoni"
    )
    assert_equal(response, service_response.body)
  end

  def test_list_examples
    response = {
      "examples" => [
        {
          "text" => "Can I order a pizza?",
          "created" => "2016-07-11T16:39:01.774Z",
          "updated" => "2015-12-07T18:53:59.153Z"
        }, {
          "text" => "Gimme a pizza with pepperoni",
          "created" => "2016-07-11T16:39:01.774Z",
          "updated" => "2015-12-07T18:53:59.153Z"
        }
      ],
      "pagination" => {
        "refresh_url" => "/v1/workspaces/pizza_app-e0f3/intents/order/examples?version=2017-12-18&page_limit=2",
        "next_url" => "/v1/workspaces/pizza_app-e0f3/intents/order/examples?cursor=base64=&version=2017-12-18&page_limit=2"
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order/examples?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_examples(
      workspace_id: "boguswid",
      intent: "pizza_order"
    )
    assert_equal(response, service_response.body)
  end

  def test_update_example
    response = {
      "text" => "Gimme a pizza with pepperoni",
      "created" => "2016-07-11T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order/examples/Gimme%20a%20pizza%20with%20pepperoni?version=2018-02-16")
      .with(
        body: "{\"text\":\"Gimme a pizza with pepperoni\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.update_example(
      workspace_id: "boguswid",
      intent: "pizza_order",
      text: "Gimme a pizza with pepperoni",
      new_text: "Gimme a pizza with pepperoni"
    )
    assert_equal(response, service_response.body)
  end

  def test_create_intent
    response = {
      "intent" => "pizza_order",
      "created" => "2015-12-06T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z",
      "description" => "User wants to start a new pizza order"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents?version=2018-02-16")
      .with(
        body: "{\"intent\":\"pizza_order\",\"description\":\"User wants to start a new pizza order\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 201, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.create_intent(
      workspace_id: "boguswid",
      intent: "pizza_order",
      description: "User wants to start a new pizza order"
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_intent
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "{}", headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_intent(
      workspace_id: "boguswid",
      intent: "pizza_order"
    )
    assert(service_response.nil?)
  end

  def test_get_intent
    response = {
      "intent" => "pizza_order",
      "created" => "2015-12-06T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z",
      "description" => "User wants to start a new pizza order"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order?export=false&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.get_intent(
      workspace_id: "boguswid",
      intent: "pizza_order",
      export: false
    )
    assert_equal(response, service_response.body)
  end

  def test_list_intents
    response = {
      "intents" => [
        {
          "intent" => "pizza_order",
          "created" => "2015-12-06T23:53:59.153Z",
          "updated" => "2015-12-07T18:53:59.153Z",
          "description" => "User wants to start a new pizza order"
        }
      ],
      "pagination" => {
        "refresh_url" => "/v1/workspaces/pizza_app-e0f3/intents?version=2017-12-18&page_limit=1",
        "next_url" => "/v1/workspaces/pizza_app-e0f3/intents?cursor=base64=&version=2017-12-18&page_limit=1"
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents?export=false&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_intents(
      workspace_id: "boguswid",
      export: false
    )
    assert_equal(response, service_response.body)
  end

  def test_update_intent
    response = {
      "intent" => "pizza_order",
      "created" => "2015-12-06T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z",
      "description" => "User wants to start a new pizza order"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/intents/pizza_order?version=2018-02-16")
      .with(
        body: "{\"intent\":\"pizza_order\",\"description\":\"User wants to start a new pizza order\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.update_intent(
      workspace_id: "boguswid",
      intent: "pizza_order",
      new_intent: "pizza_order",
      new_description: "User wants to start a new pizza order"
    )
    assert_equal(response, service_response.body)
  end

  def test_list_logs
    response = {
      "logs" => [
        {
          "request" => {
            "input" => {
              "text" => "Can you turn off the AC"
            },
            "context" => {
              "conversation_id" => "f2c7e362-4cc8-4761-8b0f-9ccd70c63bca",
              "system" => {}
            }
          },
          "response" => {
            "input" => {
              "text" => "Can you turn off the AC"
            },
            "context" => {
              "conversation_id" => "f2c7e362-4cc8-4761-8b0f-9ccd70c63bca",
              "system" => {
                "dialog_stack" => ["root"],
                "dialog_turn_counter" => 1,
                "dialog_request_counter" => 1
              },
              "defaultCounter" => 0
            },
            "entities" => [],
            "intents" => [
              {
                "intent" => "turn_off",
                "confidence" => 0.9332477126694649
              }
            ],
            "output" => {
              "log_messages" => [],
              "text" => [
                "Hi. It looks like a nice drive today. What would you like me to do?"
              ],
              "nodes_visited" => ["node_1_1467221909631"]
            }
          },
          "request_timestamp" => "2016-07-16T09:22:38.960Z",
          "response_timestamp" => "2016-07-16T09:22:39.011Z",
          "log_id" => "e70d6c12-582d-47a8-a6a2-845120a1f232"
        }
      ],
      "pagination" => {
        "next_url" =>
        "/v1/workspaces/15fb0e8a-463d-4fec-86aa-a737d9c38a32/logs?cursor=dOfVSuh6fBpDuOxEL9m1S7JKDV7KLuBmRR+lQG1s1i/rVnBZ0ZBVCuy53ruHgPImC31gQv5prUsJ77e0Mj+6sGu/yfusHYF5&version=2016-07-11&filter=response.top_intent:turn_off&page_limit=1",
        "matched" => 215
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/logs?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_logs(
      workspace_id: "boguswid"
    )
    assert_equal(response, service_response.body)
  end

  def test_list_all_logs
    response = {
      "logs" => [
        {
          "request" => {
            "input" => {
              "text" => "Good morning"
            },
            "context" => {
              "metadata" => {
                "deployment" => "deployment_1"
              }
            }
          },
          "response" => {
            "intents" => [
              {
                "intent" => "hello",
                "confidence" => 1
              }
            ],
            "entities" => [],
            "input" => {
              "text" => "Good morning"
            },
            "output" => {
              "text" => ["Hi! What can I do for you?"],
              "nodes_visited" => ["node_2_1501875253968"],
              "log_messages" => []
            },
            "context" => {
              "metadata" => {
                "deployment" => "deployment_1"
              },
              "conversation_id" => "81a43b48-7dca-4a7d-a0d7-6fed03fcee69",
              "system" => {
                "dialog_stack" => [
                  {
                    "dialog_node" => "root"
                  }
                ],
                "dialog_turn_counter" => 1,
                "dialog_request_counter" => 1,
                "_node_output_map" => {
                  "node_2_1501875253968" => [0]
                },
                "branch_exited" => true,
                "branch_exited_reason" => "completed"
              }
            }
          },
          "language" => "en",
          "workspace_id" => "9978a49e-ea89-4493-b33d-82298d3db20d",
          "request_timestamp" => "2017-09-13T19:52:32.611Z",
          "response_timestamp" => "2017-09-13T19:52:32.628Z",
          "log_id" => "aa886a8a-bac5-4b91-8323-2fd61a69c9d3"
        }
      ],
      "pagination" => {}
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/logs?filter=language::en,request.context.metadata.deployment::deployment_1&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_all_logs(
      filter: "language::en,request.context.metadata.deployment::deployment_1"
    )
    assert_equal(response, service_response.body)
  end

  def test_message
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    workspace_id = "f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec"
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
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec/message?version=2018-02-16")
      .with(
        body: "{\"input\":{\"text\":\"Turn on the lights\"}}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)
    service_response = service.message(
      workspace_id: workspace_id,
      input: { "text" => "Turn on the lights" },
      context: nil
    )
    assert_equal(message_response, service_response.body)

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
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/f8fdbc65-e0bd-4e43-b9f8-2975a366d4ec/message?version=2018-02-16")
      .with(
        body: "{\"input\":{\"text\":\"Turn on the lights\"},\"context\":\"{\\\"conversation_id\\\":\\\"1b7b67c0-90ed-45dc-8508-9488bc483d5b\\\",\\\"system\\\":{\\\"dialog_stack\\\":[\\\"root\\\"],\\\"dialog_turn_counter\\\":2,\\\"dialog_request_counter\\\":1}}\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)
    service_response = service.message(
      workspace_id: workspace_id,
      input: { "text" => "Turn on the lights" },
      context: message_ctx["context"].to_json
    )
    assert_equal(message_response, service_response.body)
  end

  def test_create_synonym
    response = {
      "synonym" => "aeiou",
      "created" => "2000-01-23T04:56:07.000+00:00",
      "updated" => "2000-01-23T04:56:07.000+00:00"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/aeiou/values/vowel/synonyms?version=2018-02-16")
      .with(
        body: "{\"synonym\":\"a\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 201, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.create_synonym(
      workspace_id: "boguswid",
      entity: "aeiou",
      value: "vowel",
      synonym: "a"
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_synonym
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/aeiou/values/vowel/synonyms/a?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_synonym(
      workspace_id: "boguswid",
      entity: "aeiou",
      value: "vowel",
      synonym: "a"
    )
    assert(service_response.nil?)
  end

  def test_get_synonym
    response = {
      "synonym" => "barbecue",
      "created" => "2015-12-06T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values/bbq/synonyms/barbecue?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.get_synonym(
      workspace_id: "boguswid",
      entity: "grilling",
      value: "bbq",
      synonym: "barbecue"
    )
    assert_equal(response, service_response.body)
  end

  def test_list_synonyms
    response = {
      "synonyms" => [
        {
          "synonym" => "BBQ sauce",
          "created" => "2015-12-06T23:53:59.153Z",
          "updated" => "2015-12-07T18:53:59.153Z"
        },
        {
          "synonym" => "barbecue",
          "created" => "2015-12-06T23:53:59.153Z",
          "updated" => "2015-12-07T18:53:59.153Z"
        }
      ],
      "pagination" => {
        "refresh_url" => "/v1/workspaces/pizza_app-e0f3/entities/sauce/values/types/synonyms?version=2017-12-18&filter=name:b&include_count=true&page_limit=2",
        "next_url" => "/v1/workspaces/pizza_app-e0f3/entities/sauce/values/types/synonyms?cursor=base64=&version=2017-12-18&filter=name:b&page_limit=2",
        "total" => 8,
        "matched" => 2
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values/bbq/synonyms?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_synonyms(
      workspace_id: "boguswid",
      entity: "grilling",
      value: "bbq"
    )
    assert_equal(response, service_response.body)
  end

  def test_update_synonym
    response = {
      "synonym" => "barbecue",
      "created" => "2015-12-06T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values/bbq/synonyms/barbecue?version=2018-02-16")
      .with(
        body: "{\"synonym\":\"barbecue\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.update_synonym(
      workspace_id: "boguswid",
      entity: "grilling",
      value: "bbq",
      synonym: "barbecue",
      new_synonym: "barbecue"
    )
    assert_equal(response, service_response.body)
  end

  def test_create_value
    response = {
      "metadata" => "{}",
      "created" => "2000-01-23T04:56:07.000+00:00",
      "value" => "aeiou",
      "type" => "synonyms",
      "updated" => "2000-01-23T04:56:07.000+00:00"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values?version=2018-02-16")
      .with(
        body: "{\"value\":\"aeiou\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 201, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.create_value(
      workspace_id: "boguswid",
      entity: "grilling",
      value: "aeiou"
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_value
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values/bbq?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_value(
      workspace_id: "boguswid",
      entity: "grilling",
      value: "bbq"
    )
    assert(service_response.nil?)
  end

  def test_get_value
    response = {
      "value" => "BBQ sauce",
      "metadata" => {
        "code" => 1422
      },
      "type" => "synonyms",
      "created" => "2015-12-06T23:53:59.153Z",
      "updated" => "2015-12-07T18:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values/bbq?export=true&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.get_value(
      workspace_id: "boguswid",
      entity: "grilling",
      value: "bbq",
      export: true
    )
    assert_equal(response, service_response.body)
  end

  def test_list_values
    response = {
      "values" => [
        {
          "value" => "BBQ sauce",
          "metadata" => {
            "code" => 1422
          },
          "type" => "synonyms",
          "created" => "2015-12-06T23:53:59.153Z",
          "updated" => "2015-12-07T18:53:59.153Z"
        }
      ],
      "pagination" => {
        "refresh_url" => "/v1/workspaces/pizza_app-e0f3/entities/sauce/values?version=2017-12-18&filter=name:pizza&include_count=true&page_limit=1",
        "next_url" => "/v1/workspaces/pizza_app-e0f3/sauce/values?cursor=base64=&version=2017-12-18&filter=name:pizza&page_limit=1",
        "total" => 1,
        "matched" => 1
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values?export=true&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_values(
      workspace_id: "boguswid",
      entity: "grilling",
      export: true
    )
    assert_equal(response, service_response.body)
  end

  def test_update_value
    response = {
      "value" => "BBQ sauce",
      "metadata" => {
        "code" => 1422
      },
      "type" => "synonyms",
      "created" => "2015-12-06T23:53:59.153Z",
      "updated" => "2015-12-06T23:53:59.153Z"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid/entities/grilling/values/bbq?version=2018-02-16")
      .with(
        body: "{\"value\":\"BBQ sauce\",\"metadata\":{\"code\":1422}}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.update_value(
      workspace_id: "boguswid",
      entity: "grilling",
      value: "bbq",
      new_value: "BBQ sauce",
      new_metadata: { "code" => 1422 },
      new_synonyms: nil
    )
    assert_equal(response, service_response.body)
  end

  def test_create_workspace
    response = {
      "name" => "Pizza app",
      "created" => "2015-12-06T23:53:59.153Z",
      "language" => "en",
      "metadata" => {},
      "updated" => "2015-12-06T23:53:59.153Z",
      "description" => "Pizza app",
      "workspace_id" => "pizza_app-e0f3"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces?version=2018-02-16")
      .with(
        body: "{\"name\":\"Pizza app\",\"description\":\"Pizza app\",\"language\":\"en\",\"metadata\":{}}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 201, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.create_workspace(
      name: "Pizza app",
      description: "Pizza app",
      language: "en",
      metadata: {}
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_workspace
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_workspace(
      workspace_id: "boguswid"
    )
    assert(service_response.nil?)
  end

  def test_get_workspace
    response = {
      "name" => "Pizza app",
      "created" => "2015-12-06T23:53:59.153Z",
      "language" => "en",
      "metadata" => {},
      "updated" => "2015-12-06T23:53:59.153Z",
      "description" => "Pizza app",
      "status" => "Available",
      "learning_opt_out" => false,
      "workspace_id" => "pizza_app-e0f3"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/boguswid?export=false&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.get_workspace(
      workspace_id: "boguswid",
      export: false
    )
    assert_equal(response, service_response.body)
  end

  def test_list_workspaces
    response = {
      "workspaces" => [
        {
          "name" => "Pizza app",
          "created" => "2015-12-06T23:53:59.153Z",
          "language" => "en",
          "metadata" => {},
          "updated" => "2015-12-06T23:53:59.153Z",
          "description" => "Pizza app",
          "workspace_id" => "pizza_app-e0f3"
        }
      ],
      "pagination" => {
        "refresh_url" => "/v1/workspaces?version=2016-01-24&page_limit=1",
        "next_url" => "/v1/workspaces?cursor=base64=&version=2016-01-24&page_limit=1"
      }
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.list_workspaces
    assert_equal(response, service_response.body)
  end

  def test_update_workspace
    response = {
      "name" => "Pizza app",
      "created" => "2015-12-06T23:53:59.153Z",
      "language" => "en",
      "metadata" => {},
      "updated" => "2015-12-06T23:53:59.153Z",
      "description" => "Pizza app",
      "workspace_id" => "pizza_app-e0f3"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/pizza_app-e0f3?version=2018-02-16")
      .with(
        body: "{\"name\":\"Pizza app\",\"description\":\"Pizza app\",\"language\":\"en\",\"metadata\":{}}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.update_workspace(
      workspace_id: "pizza_app-e0f3",
      name: "Pizza app",
      description: "Pizza app",
      language: "en",
      metadata: {}
    )
    assert_equal(response, service_response.body)
  end

  def test_dialog_nodes
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    headers = {
      "Content-Type" => "application/json"
    }

    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/id/dialog_nodes?version=2018-02-16")
      .with(
        body: "{\"dialog_node\":\"location-done\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "application/json" => { "dialog_node" => "location-done" } }.to_json, headers: headers)
    service_response = service.create_dialog_node(
      workspace_id: "id",
      dialog_node: "location-done"
    )
    assert_equal("location-done", service_response.body["application/json"]["dialog_node"])

    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/id/dialog_nodes/location-done?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "description" => "deleted successfully" }.to_json, headers: headers)
    service_response = service.delete_dialog_node(
      workspace_id: "id",
      dialog_node: "location-done"
    )
    assert(service_response.nil?)

    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/id/dialog_nodes/location-done?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "application/json" => { "dialog_node" => "location-atm" } }.to_json, headers: headers)
    service_response = service.get_dialog_node(
      workspace_id: "id",
      dialog_node: "location-done"
    )
    assert_equal({ "application/json" => { "dialog_node" => "location-atm" } }, service_response.body)

    stub_request(:get, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/id/dialog_nodes?version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "application/json" => { "dialog_node" => "location-atm" } }.to_json, headers: headers)
    service_response = service.list_dialog_nodes(
      workspace_id: "id"
    )
    assert_equal({ "application/json" => { "dialog_node" => "location-atm" } }, service_response.body)
  end

  def test_delete_user_data
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:delete, "https://gateway.watsonplatform.net/assistant/api/v1/user_data?customer_id=id&version=2018-02-16")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: headers)
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    service_response = service.delete_user_data(
      customer_id: "id"
    )
    assert(service_response.nil?)
  end

  def test_update_dialog_node
    service = IBMWatson::AssistantV1.new(
      username: "username",
      password: "password",
      version: "2018-02-16"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/assistant/api/v1/workspaces/workspace_id/dialog_nodes/dialog_node?version=2018-02-16")
      .with(
        body: "{\"description\":\"A new description\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "Pseudo update dialog node response", headers: {})
    service_response = service.update_dialog_node(
      workspace_id: "workspace_id",
      dialog_node: "dialog_node",
      new_description: "A new description"
    )
    assert_equal("Pseudo update dialog node response", service_response.body)
  end
end
