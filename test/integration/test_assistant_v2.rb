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
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["ASSISTANT_APIKEY"],
        url: ENV["ASSISTANT_AUTH_URL"]
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

      service_response = service.message_stateless(
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"],
        input: { "text" => "Turn on the lights" },
        context: nil
      )
      assert((200..299).cover?(service_response.status))

      service.delete_session(
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"],
        session_id: session_id
      )
    end

    def test_list_logs
      skip "Premium plan only.  Need Premium credentials"

      service_response = service.list_logs(
        assistant_id: ENV["ASSISTANT_ASSISTANT_ID"]
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_delete_user_data
      skip "Covered with the unit test.  No need to run it here"

      service_response = service.delete_user_data(
        customer_id: ENV["ASSISTANT_ASSISTANT_ID"]
      )
      assert(service_response.nil?)
    end
  end
end
