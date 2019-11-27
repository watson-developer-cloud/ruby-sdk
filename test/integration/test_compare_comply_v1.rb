# frozen_string_literal: true

require_relative("./../test_helper.rb")
require("minitest/hooks/test")
require("ibm_cloud_sdk_core")

if !ENV["COMPARE_COMPLY_APIKEY"].nil?
  # Integration tests for the Discovery V1 Service
  class CompareComplyV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service, :environment_id, :collection_id

    def before_all
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["COMPARE_COMPLY_APIKEY"]
      )
      @service = IBMWatson::CompareComplyV1.new(
        version: "2018-10-15",
        authenticator: authenticator
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_convert_to_html
      File.open(Dir.getwd + "/resources/cnc_test.pdf") do |file_info|
        response = @service.convert_to_html(
          file: file_info
        ).result
        refute(response.nil?)
      end
    end

    def test_classiffy_elements
      File.open(Dir.getwd + "/resources/cnc_test.pdf") do |file_info|
        response = @service.classify_elements(
          file: file_info
        ).result
        refute(response.nil?)
      end
    end

    def test_extract_tables
      File.open(Dir.getwd + "/resources/cnc_test.pdf") do |file_info|
        response = @service.extract_tables(
          file: file_info
        ).result
        refute(response.nil?)
      end
    end

    def test_compare_documents
      file_1 = File.open(Dir.getwd + "/resources/cnc_test.pdf")
      file_2 = File.open(Dir.getwd + "/resources/cnc_test.pdf")
      response = @service.compare_documents(
        file_1: file_1,
        file_2: file_2
      ).result
      refute(response.nil?)
    end

    def test_list_feedback
      response = @service.list_feedback.result
      refute(response.nil?)
    end

    def test_get_feedback
      @service_dup = IBMWatson::CompareComplyV1.new(
        iam_apikey: ENV["COMPARE_COMPLY_APIKEY"],
        version: "2018-10-15"
      )
      @service_dup.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1",
          "x-watson-metadata" => "customer_id=sdk-test-customer-id"
        }
      )
      response = @service_dup.get_feedback(
        feedback_id: ENV["COMPARE_COMPLY_FEEDBACK_ID"]
      ).result
      refute(response.nil?)
    end

    def test_create_batch
      skip "Skip to allow for concurrent travis jobs"
      input_file = File.open(Dir.getwd + "/resources/cnc_input_credentials_file.json")
      output_file = File.open(Dir.getwd + "/resources/cnc_output_credentials_file.json")
      response = @service.create_batch(
        function: "tables",
        input_credentials_file: input_file,
        input_bucket_location: "us-south",
        input_bucket_name: "compare-comply-integration-test-bucket-input",
        output_credentials_file: output_file,
        output_bucket_location: "us-south",
        output_bucket_name: "compare-comply-integration-test-bucket-output"
      ).result
      refute(response.nil?)
    end

    def test_list_batches
      response = @service.list_batches.result
      refute(response.nil?)
    end
  end
else
  class CompareComplyV1Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip discovery integration tests because credentials have not been provided"
    end
  end
end
