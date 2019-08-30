# frozen_string_literal: true

require_relative("./../test_helper.rb")
SimpleCov.command_name "test:integration"
require("minitest/hooks/test")
require("ibm_cloud_sdk_core")

if !ENV["ASSISTANT_APIKEY"].nil? && !ENV["ASSISTANT_URL"].nil?
  # Integration tests for the Watson Assistant V2 Service
  class AssistantV2Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      authenticator = IBMCloudSdkCore::IamAuthenticator.new(
        apikey: ENV["ASSISTANT_APIKEY"]
      )
      @service = IBMWatson::AssistantV2.new(
        version: "2018-12-31",
        authenticator: authenticator,
        url: ENV["ASSISTANT_URL"],
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"]
      )
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_create_delete_session_and_message
      service_response = service.create_session(
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"]
      )
      session_id = service_response.result["session_id"]
      assert((200..299).cover?(service_response.status))

      service_response = service.message(
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"],
        session_id: session_id,
        input: { "text" => "Turn on the lights" },
        context: nil
      )
      assert((200..299).cover?(service_response.status))

      context = service_response.result["context"]
      service_response = service.message(
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"],
        session_id: session_id,
        input: { "text" => "Turn on the lights" },
        context: context
      )
      assert((200..299).cover?(service_response.status))

      service.delete_session(
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"],
        session_id: session_id
      )
    end
  end
end
