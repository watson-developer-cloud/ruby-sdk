# frozen_string_literal: true

require("ibm_watson/assistant_v2")
require("json")

# If you have username & password in your credentials use:
service = IBMWatson::AssistantV2.new(
  username: "YOUR SERVICE USERNAME",
  password: "YOUR SERVICE PASSWORD",
  version: "2018-09-17"
)

# If using IAM
# assistant = IBMWatson::AssistantV1.new(
#   iam_apikey: "IAM API KEY",
#   version: "2018-09-17"
# )

#########################
# Sessions
#########################
response = service.create_session(
  assistant_id: "assistant_id"
)

puts JSON.pretty_generate(response.result)

session_id = response.result["session_id"]
service.delete_session(
  assistant_id: "assistant_id",
  session_id: session_id
)

#########################
# Message
#########################
response = service.message(
  assistant_id: "assistant_id",
  session_id: "session_id",
  input: { "text" => "Turn on the lights" },
  context: nil
)
puts JSON.pretty_generate(response.result)
