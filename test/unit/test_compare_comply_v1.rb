# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")
SimpleCov.command_name "test:unit"

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Watson Assistant V1 Service
class CompareComplyV1 < Minitest::Test
  def test_convert_to_html
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/html_conversion").with do |req|
      # Test the headers.
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
    end
    service.convert_to_html(
      file: file
    )
    service.convert_to_html(
      file: "dummy",
      filename: "file"
    )
  end

  def test_classify_elements
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/element_classification").with do |req|
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
      assert_match(/Content-Disposition: form-data/, req.body)
    end
    service.classify_elements(
      file: file
    )
    service.classify_elements(
      file: "dummy",
      filename: "file"
    )
  end

  def test_extract_tables
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/tables").with do |req|
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
      assert_match(/Content-Disposition: form-data/, req.body)
    end
    service.extract_tables(
      file: file
    )
    service.extract_tables(
      file: "dummy",
      filename: "file"
    )
  end

  def test_compare_documents
    # service.set_default_headers("x-watson-learning-opt-out" => true)
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/comparison").with do |req|
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
      assert_match(/Content-Disposition: form-data/, req.body)
    end
    service.compare_documents(
      file_1: file,
      file_2: file
    )
    service.compare_documents(
      file_1: "dummy data",
      file_1_filename: "file1",
      file_2: "dummy data",
      file_2_filename: "file1"
    )
  end

  def test_list_feedback
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    message_response = {
      "feedback" => [
        {
          "feedback_id" => "another_one",
          "text" => "we the best music"
        }
      ]
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer token",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.list_feedback
    assert_equal(message_response, service_response.result)
  end

  def test_add_feedback
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    message_response = {
      "feedback_id" => "another_one"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer token",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.add_feedback(
      feedback_data: "we the best music"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_get_feedback
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    message_response = {
      "feedback_id" => "messi"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback/messi")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer token",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.get_feedback(
      feedback_id: "messi"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_delete_feedback
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    message_response = "200"
    stub_request(:delete, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback/messi")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer token",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response, headers: {})

    service_response = service.delete_feedback(
      feedback_id: "messi"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_create_batch
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches?function=tables")
      .with do |req|
        assert_equal req.headers["Accept"], "application/json"
        assert_match %r{\Amultipart/form-data}, req.headers["Content-Type"]
      end

    service.create_batch(
      function: "tables",
      input_credentials_file: { key: "ip" },
      input_bucket_location: "us",
      input_bucket_name: "bucket",
      output_credentials_file: { key: "op" },
      output_bucket_location: "you",
      output_bucket_name: "obucket"
    )
  end

  def test_list_batches
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    message_response = {
      "batches" => []
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer token",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.list_batches
    assert_equal(message_response, service_response.result)
  end

  def test_get_batch
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    message_response = "200"
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches/mo")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer token",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response, headers: {})

    service_response = service.get_batch(
      batch_id: "mo"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_update_batch
    service = IBMWatson::CompareComplyV1.new(
      iam_apikey: "apikey",
      iam_access_token: "token"
    )
    message_response = "200"
    stub_request(:put, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches/mo?action=goal")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Bearer token",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response, headers: {})

    service_response = service.update_batch(
      batch_id: "mo",
      action: "goal"
    )
    assert_equal(message_response, service_response.result)
  end
end
