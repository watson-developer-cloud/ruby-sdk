# frozen_string_literal: true

require("ibm_watson/assistant_v1")
require("json")

# If using IAM
assistant = IBMWatson::AssistantV1.new(
  iam_apikey: "IAM API KEY",
  version: "2018-02-16"
)

# If you have username & password in your credentials use:
# assistant = AssistantV1(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD",
#   version: "2018-02-16"
# )

#########################
# Workspaces
#########################

create_workspace_data = {
  "name" => "test_workspace",
  "description" => "integration tests",
  "language" => "en",
  "intents" => [
    {
      "intent" => "hello",
      "description" => "string",
      "examples" => [
        {
          "text" => "good morning"
        }
      ]
    }
  ],
  "entities" => [
    {
      "entity" => "pizza_toppings",
      "description" => "Tasty pizza toppings",
      "metadata" => {
        "property" => "value"
      }
    }
  ],
  "counterexamples" => [
    {
      "text" => "string"
    }
  ],
  "metadata" => {}
}

response = assistant.create_workspace(
  name: create_workspace_data["name"],
  description: create_workspace_data["description"],
  language: "en",
  intents: create_workspace_data["intents"],
  entities: create_workspace_data["entities"],
  counterexamples: create_workspace_data["counterexamples"],
  metadata: create_workspace_data["metadata"]
).result
puts JSON.pretty_generate(response)

workspace_id = response["workspace_id"]
p "Workspace id #{workspace_id}"

response = assistant.get_workspace(
  workspace_id: workspace_id,
  export: true
).result
puts JSON.pretty_generate(response)

#  message
response = assistant.message(
  workspace_id: workspace_id,
  input: {
    "text" => "What's the weather like?"
  },
  context: {
    "metadata" => {
      "deployment" => "myDeployment"
    }
  }
).result
puts JSON.pretty_generate(response)

response = assistant.list_workspaces.result
puts JSON.pretty_generate(response)

response = assistant.update_workspace(
  workspace_id: workspace_id,
  description: "Updated test workspace."
).result
puts JSON.pretty_generate(response)

# see cleanup section below for delete_workspace example

#########################
# Intents
#########################

examples = [{ "text" => "good morning" }]
response = assistant.create_intent(
  workspace_id: workspace_id,
  intent: "test_intent",
  description: "Test intent.",
  examples: examples
).result
puts JSON.pretty_generate(response)

response = assistant.get_intent(
  workspace_id: workspace_id,
  intent: "test_intent",
  export: true
).result
puts JSON.pretty_generate(response)

response = assistant.list_intents(
  workspace_id: workspace_id,
  export: true
).result
puts JSON.pretty_generate(response)

response = assistant.update_intent(
  workspace_id: workspace_id,
  intent: "test_intent",
  new_intent: "updated_test_intent",
  new_description: "Updated test intent."
).result
puts JSON.pretty_generate(response)

# see cleanup section below for delete_intent example

#########################
# Examples
#########################

response = assistant.create_example(
  workspace_id: workspace_id,
  intent: "updated_test_intent",
  text: "Gimme a pizza with pepperoni"
).result
puts JSON.pretty_generate(response)

response = assistant.get_example(
  workspace_id: workspace_id,
  intent: "updated_test_intent",
  text: "Gimme a pizza with pepperoni"
).result
puts JSON.pretty_generate(response)

response = assistant.list_examples(
  workspace_id: workspace_id,
  intent: "updated_test_intent"
).result
puts JSON.pretty_generate(response)

response = assistant.update_example(
  workspace_id: workspace_id,
  intent: "updated_test_intent",
  text: "Gimme a pizza with pepperoni",
  new_text: "Gimme a pizza with pepperoni"
).result
puts JSON.pretty_generate(response)

response = assistant.delete_example(
  workspace_id: workspace_id,
  intent: "updated_test_intent",
  text: "Gimme a pizza with pepperoni"
).result
puts JSON.pretty_generate(response)

#########################
# Counter Examples
#########################

response = assistant.create_counterexample(
  workspace_id: workspace_id,
  text: "I want financial advice today."
).result
puts JSON.pretty_generate(response)

response = assistant.get_counterexample(
  workspace_id: workspace_id,
  text: "I want financial advice today."
).result
puts JSON.pretty_generate(response)

response = assistant.list_counterexamples(workspace_id: workspace_id).result
puts JSON.pretty_generate(response)

response = assistant.update_counterexample(
  workspace_id: workspace_id,
  text: "I want financial advice today.",
  new_text: "I want financial advice today."
).result
puts JSON.pretty_generate(response)

response = assistant.delete_counterexample(
  workspace_id: workspace_id,
  text: "I want financial advice today."
).result
puts JSON.pretty_generate(response)

#########################
# Entities
#########################

values = [{ "value" => "juice" }]
response = assistant.create_entity(
  workspace_id: workspace_id,
  entity: "test_entity",
  description: "A test entity.",
  values: values
).result
puts JSON.pretty_generate(response)

entities = [
  {
    "entity" => "pattern_entity",
    "values" => [
      {
        "value" => "value0",
        "patterns" => ["\\d{6}\\w{1}\\d{7}"],
        "value_type" => "patterns"
      },
      {
        "value" => "value1",
        "patterns" => ["[-9][0-9][0-9][0-9][0-9]~! [1-9][1-9][1-9][1-9][1-9][1-9]"],
        "value_type" => "patterns"
      },
      {
        "value" => "value2",
        "patterns" => ["[a-z-9]{17}"],
        "value_type" => "patterns"
      },
      {
        "value" => "value3",
        "patterns" => [
          "\\d{3}(\\ |-)\\d{3}(\\ |-)\\d{4}",
          "\\(\\d{3}\\)(\\ |-)\\d{3}(\\ |-)\\d{4}"
        ],
        "value_type" => "patterns"
      },
      {
        "value" => "value4",
        "patterns" => ["\\b\\d{5}\\b"],
        "value_type" => "patterns"
      }
    ]
  }
]
response = assistant.create_entity(
  workspace_id: workspace_id,
  entity: entities[0]["entity"],
  values: entities[0]["values"]
).result
puts JSON.pretty_generate(response)

response = assistant.get_entity(
  workspace_id: workspace_id,
  entity: entities[0]["entity"],
  export: true
).result
puts JSON.pretty_generate(response)

response = assistant.list_entities(workspace_id: workspace_id).result
puts JSON.pretty_generate(response)

response = assistant.update_entity(
  workspace_id: workspace_id,
  entity: "test_entity",
  new_description: "An updated test entity."
).result
puts JSON.pretty_generate(response)

response = assistant.delete_entity(
  workspace_id: workspace_id,
  entity: "test_entity"
).result
puts JSON.pretty_generate(response)

#########################
# Synonyms
#########################

values = [{ "value" => "orange juice" }]
assistant.create_entity(
  workspace_id: workspace_id,
  entity: "beverage",
  values: values
)

response = assistant.create_synonym(
  workspace_id: workspace_id,
  entity: "beverage",
  value: "orange juice",
  synonym: "oj"
).result
puts JSON.pretty_generate(response)

response = assistant.get_synonym(
  workspace_id: workspace_id,
  entity: "beverage",
  value: "orange juice",
  synonym: "oj"
).result
puts JSON.pretty_generate(response)

response = assistant.list_synonyms(
  workspace_id: workspace_id,
  entity: "beverage",
  value: "orange juice"
).result
puts JSON.pretty_generate(response)

response = assistant.update_synonym(
  workspace_id: workspace_id,
  entity: "beverage",
  value: "orange juice",
  synonym: "oj",
  new_synonym: "OJ"
).result
puts JSON.pretty_generate(response)

response = assistant.delete_synonym(
  workspace_id: workspace_id,
  entity: "beverage",
  value: "orange juice",
  synonym: "OJ"
).result
puts JSON.pretty_generate(response)

assistant.delete_entity(workspace_id: workspace_id, entity: "beverage")

#########################
# Values
#########################

assistant.create_entity(workspace_id: workspace_id, entity: "test_entity")

response = assistant.create_value(
  workspace_id: workspace_id,
  entity: "test_entity",
  value: "test"
).result
puts JSON.pretty_generate(response)

response = assistant.get_value(
  workspace_id: workspace_id,
  entity: "test_entity",
  value: "test"
).result
puts JSON.pretty_generate(response)

response = assistant.list_values(
  workspace_id: workspace_id,
  entity: "test_entity"
).result
puts JSON.pretty_generate(response)

response = assistant.update_value(
  workspace_id: workspace_id,
  entity: "test_entity",
  value: "test",
  new_value: "example"
).result
puts JSON.pretty_generate(response)

response = assistant.delete_value(
  workspace_id: workspace_id,
  entity: "test_entity",
  value: "example"
).result
puts JSON.pretty_generate(response)

assistant.delete_entity(workspace_id: workspace_id, entity: "test_entity")

#########################
# Dialog nodes
#########################
create_dialog_node = {
  "dialog_node" => "greeting",
  "description" => "greeting messages",
  "actions" => [
    {
      "name" => "hello",
      "type" => "client",
      "parameters" => {},
      "result_variable" => "string",
      "credentials" => "string"
    }
  ]
}
response = assistant.create_dialog_node(
  workspace_id: workspace_id,
  dialog_node: create_dialog_node["dialog_node"],
  description: create_dialog_node["description"],
  actions: create_dialog_node["actions"]
).result
puts JSON.pretty_generate(response)

response = assistant.get_dialog_node(
  workspace_id: workspace_id,
  dialog_node: create_dialog_node["dialog_node"]
).result
puts JSON.pretty_generate(response)

response = assistant.list_dialog_nodes(workspace_id: workspace_id).result
puts JSON.pretty_generate(response)

response = assistant.update_dialog_node(
  workspace_id: workspace_id,
  dialog_node: create_dialog_node["dialog_node"],
  new_dialog_node: "updated_node"
).result
puts JSON.pretty_generate(response)

response = assistant.delete_dialog_node(workspace_id: workspace_id, dialog_node: "updated_node").result
puts JSON.pretty_generate(response)

#########################
# Logs
#########################

response = assistant.list_logs(workspace_id: workspace_id).result
puts JSON.pretty_generate(response)

#########################
# Clean-up
#########################

response = assistant.delete_intent(
  workspace_id: workspace_id,
  intent: "updated_test_intent"
).result
puts JSON.pretty_generate(response)

response = assistant.delete_workspace(workspace_id: workspace_id).result
puts JSON.pretty_generate(response)
