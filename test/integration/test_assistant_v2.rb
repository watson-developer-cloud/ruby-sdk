# frozen_string_literal: true

require_relative("./../test_helper.rb")
SimpleCov.command_name "test:integration"

if !ENV["ASSISTANT_V2_USERNAME"].nil? && !ENV["ASSISTANT_V2_PASSWORD"].nil?
  # Integration tests for the Watson Assistant V2 Service
  class AssistantV2Test < Minitest::Test
    def test_create_delete_session
      # skip "Skip to allow for concurrent travis jobs"
      service = IBMWatson::AssistantV2.new(
        version: "2018-12-31",
        username: ENV["ASSISTANT_V2_USERNAME"],
        password: ENV["ASSISTANT_V2_PASSWORD"],
        url: ENV["ASSISTANT_V2_URL"],
        assistant_id: ENV["ASSISTANT_V2_ASSISTANT_ID"]
      )
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.create_session(
        assistant_id: ENV["ASSISTANT_V2_ASSISTANT_ID"]
      )
      session_id = service_response.result["session_id"]
      assert((200..299).cover?(service_response.status))
      service.delete_session(
        assistant_id: ENV["ASSISTANT_V2_ASSISTANT_ID"],
        session_id: session_id
      )
    end

    def test_message
      service = IBMWatson::AssistantV2.new(
        username: ENV["ASSISTANT_V2_USERNAME"],
        password: ENV["ASSISTANT_V2_PASSWORD"],
        version: "2018-02-16",
        url: ENV["ASSISTANT_V2_URL"]
      )
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.message(
        assistant_id: ENV["ASSISTANT_V2_ASSISTANT_ID"],
        session_id: ENV["ASSISTANT_V2_SESSION_ID"],
        input: { "text" => "Turn on the lights" },
        context: nil
      )
      assert((200..299).cover?(service_response.status))

      context = service_response.result["context"]
      service_response = service.message(
        assistant_id: ENV["ASSISTANT_V2_ASSISTANT_ID"],
        session_id: ENV["ASSISTANT_V2_SESSION_ID"],
        input: { "text" => "Turn on the lights" },
        context: context
      )
      assert((200..299).cover?(service_response.status))
    end
  end
end
