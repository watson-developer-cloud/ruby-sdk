# frozen_string_literal: true

require_relative("./../test_helper.rb")
SimpleCov.command_name "test:integration"
require("minitest/hooks/test")

if !ENV["ASSISTANT_APIKEY"].nil? && !ENV["ASSISTANT_URL"].nil?
  # Integration tests for the Watson Assistant V1 Service
  class AssistantV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      @service = IBMWatson::AssistantV1.new(
        iam_apikey: ENV["ASSISTANT_APIKEY"],
        url: ENV["ASSISTANT_URL"],
        version: "2018-02-16"
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_create_update_delete_workspace
      skip "Skip to allow for concurrent travis jobs"
      service_response = service.create_workspace(
        name: "Pizza app",
        description: "Pizza app",
        language: "en",
        metadata: {}
      )
      workspace_id = service_response.result["workspace_id"]
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
      service_response = service.get_workspace(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        export: false
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_workspaces
      service_response = service.list_workspaces
      assert((200..299).cover?(service_response.status))
    end

    def test_create_update_delete_counterexample
      skip "Skip to allow for concurrent travis jobs"
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

      service_response = service.get_counterexample(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        text: "I want a large pizza please."
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.delete_counterexample(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        text: "I want a large pizza please."
      )
      assert(service_response.nil?)
    end

    def test_list_counterexamples
      service_response = service.list_counterexamples(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"]
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_create_update_delete_entity
      skip "Skip to allow for concurrent travis jobs"
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
      service_response = service.get_entity(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        entity: "holiday",
        export: true
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_entities
      service_response = service.list_entities(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        export: true
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_create_update_delete_example
      skip "Skip to allow for concurrent travis jobs"
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
      service_response = service.get_example(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        intent: "Cancel",
        text: "forget it"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_examples
      service_response = service.list_examples(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        intent: "Cancel"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_create_update_delete_intent
      skip "Skip to allow for concurrent travis jobs"
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
      service_response = service.get_intent(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        intent: "Cancel",
        export: false
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_intents
      service_response = service.list_intents(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        export: false
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_logs
      service_response = service.list_logs(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"]
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_all_logs
      service_response = service.list_all_logs(
        filter: "language::en,request.context.metadata.deployment::deployment_1"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_message
      service_response = service.message(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        input: { "text" => "Turn on the lights" },
        context: nil
      )
      assert((200..299).cover?(service_response.status))

      context = service_response.result["context"]
      service_response = service.message(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        input: { "text" => "Turn on the lights" },
        context: context
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_create_update_delete_synonym
      skip "Skip to allow for concurrent travis jobs"
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
      service_response = service.get_synonym(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        entity: "holiday",
        value: "thanksgiving",
        synonym: "turkey day"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_synonyms
      service_response = service.list_synonyms(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        entity: "holiday",
        value: "new years eve"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_create_update_delete_value
      skip "Skip to allow for concurrent travis jobs"
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
      service_response = service.get_value(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        entity: "holiday",
        value: "christmas",
        export: true
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_values
      service_response = service.list_values(
        workspace_id: ENV["ASSISTANT_WORKSPACE_ID"],
        entity: "holiday",
        export: true
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_dialog_nodes
      skip "Skip to allow for concurrent travis jobs"

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
      service_response = service.delete_user_data(
        customer_id: "id"
      )
      assert(service_response.nil?)
    end
  end
else
  class AssistantV1Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip assistant integration tests because credentials have not been provided"
    end
  end
end
