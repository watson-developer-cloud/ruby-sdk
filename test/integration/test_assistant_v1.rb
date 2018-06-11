# frozen_string_literal: true

require_relative("./../../lib/watson_developer_cloud/watson_assistant_v1.rb")
require("json")
require("minitest/autorun")

# Integration tests for the Watson Assistant V1 Service
class AssistantV1Test < Minitest::Test
  Minitest::Test.parallelize_me!
  def test_create_update_delete_workspace
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.create_workspace(
      name: "Pizza app",
      description: "Pizza app",
      language: "en",
      metadata: {}
    )
    workspace_id = JSON.parse(service_response.body)["workspace_id"]
    assert((200..299).cover?(service_response.status))

    service_response = service.update_workspace(
      workspace_id: workspace_id,
      name: "Pizza app",
      description: "Pizza app",
      language: "en",
      metadata: {}
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_workspace(
      workspace_id: workspace_id
    )
    assert(service_response.nil?)
  end

  def test_get_workspace
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.get_workspace(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      export: false
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_workspaces
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_workspaces
    assert((200..299).cover?(service_response.status))
  end

  def test_create_update_delete_counterexample
    service = AssistantV1.new(
      version: "2018-02-16",
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"]
    )
    service_response = service.create_counterexample(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      text: "I want a large pizza please."
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.update_counterexample(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      text: "I want a large pizza please.",
      new_text: "I want a large pizza please."
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_counterexample(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      text: "I want a large pizza please."
    )
    assert(service_response.nil?)
  end

  def test_get_counterexample
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.get_counterexample(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      text: "what is your nickname"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_counterexamples
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_counterexamples(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"]
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_create_update_delete_entity
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.create_entity(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "pizza_toppings",
      description: "Tasty pizza toppings",
      metadata: { "property" => "value" },
      values: nil,
      fuzzy_match: nil
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.update_entity(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "pizza_toppings",
      new_entity: "pizza_toppings"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_entity(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "pizza_toppings"
    )
    assert(service_response.nil?)
  end

  def test_get_entity
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.get_entity(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      export: true
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_entities
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_entities(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      export: true
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_create_update_delete_example
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.create_example(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "Cancel",
      text: "Gimme a pizza with pepperoni"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.update_example(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "Cancel",
      text: "Gimme a pizza with pepperoni",
      new_text: "Gimme a pizza with pepperoni"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_example(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "Cancel",
      text: "Gimme a pizza with pepperoni"
    )
    assert(service_response.nil?)
  end

  def test_get_example
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.get_example(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "Cancel",
      text: "forget it"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_examples
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_examples(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "Cancel"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_create_update_delete_intent
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.create_intent(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "pizza_order",
      description: "User wants to start a new pizza order"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.update_intent(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "pizza_order",
      new_intent: "pizza_order",
      new_description: "User wants to start a new pizza order"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_intent(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "pizza_order"
    )
    assert(service_response.nil?)
  end

  def test_get_intent
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.get_intent(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      intent: "Cancel",
      export: false
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_intents
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_intents(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      export: false
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_logs
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_logs(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"]
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_all_logs
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_all_logs(
      filter: "language::en,request.context.metadata.deployment::deployment_1"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_message
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    service_response = service.message(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      input: { "text" => "Turn on the lights" },
      context: nil
    )
    assert((200..299).cover?(service_response.status))

    context = JSON.parse(service_response.body)["context"]
    service_response = service.message(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      input: { "text" => "Turn on the lights" },
      context: context
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_create_update_delete_synonym
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.create_synonym(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "labor day",
      synonym: "a"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.update_synonym(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "labor day",
      synonym: "a",
      new_synonym: "a"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_synonym(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "labor day",
      synonym: "a"
    )
    assert(service_response.nil?)
  end

  def test_get_synonym
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.get_synonym(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "thanksgiving",
      synonym: "turkey day"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_synonyms
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_synonyms(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "new years eve"
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_create_update_delete_value
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.create_value(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "aeiou"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.update_value(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "aeiou",
      new_value: "BBQ sauce",
      new_metadata: { "code" => 1422 },
      new_synonyms: nil
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_value(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "BBQ sauce"
    )
    assert(service_response.nil?)
  end

  def test_get_value
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.get_value(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      value: "christmas",
      export: true
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_list_values
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.list_values(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      entity: "holiday",
      export: true
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_dialog_nodes
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )

    service_response = service.create_dialog_node(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      dialog_node: "location-done"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.delete_dialog_node(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      dialog_node: "location-done"
    )
    assert(service_response.nil?)

    service_response = service.get_dialog_node(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
      dialog_node: "Hours of Operation"
    )
    assert((200..299).cover?(service_response.status))

    service_response = service.list_dialog_nodes(
      workspace_id: ENV["ASSISTANT_WORKSPACE_ID"]
    )
    assert((200..299).cover?(service_response.status))
  end

  def test_delete_user_data
    service = AssistantV1.new(
      username: ENV["ASSISTANT_USERNAME"],
      password: ENV["ASSISTANT_PASSWORD"],
      version: "2018-02-16"
    )
    service_response = service.delete_user_data(
      customer_id: "id"
    )
    assert(service_response.nil?)
  end
end
