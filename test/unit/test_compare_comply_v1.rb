# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")
SimpleCov.command_name "test:unit"

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Watson Assistant V1 Service
class CompareComplyV1 < Minitest::Test
  include Minitest::Hooks
  attr_accessor :service
  def before_all
    authenticator = IBMWatson::Authenticators::NoAuthAuthenticator.new
    @service = IBMWatson::CompareComplyV1.new(
      version: "2018-10-15",
      authenticator: authenticator
    )
  end

  def test_convert_to_html
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/html_conversion?version=2018-10-15").with do |req|
      # Test the headers.
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
    end
    service.convert_to_html(
      file: file
    )
  end

  def test_classify_elements
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/element_classification?version=2018-10-15").with do |req|
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
      assert_match(/Content-Disposition: form-data/, req.body)
    end
    service.classify_elements(
      file: file
    )
    service.classify_elements(
      file: "dummy"
    )
  end

  def test_extract_tables
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/tables?version=2018-10-15").with do |req|
      assert_equal(req.headers["Accept"], "application/json")
      assert_match(%r{\Amultipart/form-data}, req.headers["Content-Type"])
      assert_match(/Content-Disposition: form-data/, req.body)
    end
    service.extract_tables(
      file: file
    )
    service.extract_tables(
      file: "dummy"
    )
  end

  def test_compare_documents
    file = File.open(Dir.getwd + "/resources/cnc_test.pdf")
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/comparison?version=2018-10-15").with do |req|
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
      file_2: "dummy data"
    )
  end

  def test_list_feedback
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
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback?version=2018-10-15")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.list_feedback
    assert_equal(message_response, service_response.result)
  end

  def test_add_feedback
    message_response = {
      "feedback_id" => "another_one"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback?version=2018-10-15")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.add_feedback(
      feedback_data: "we the best music"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_get_feedback
    message_response = {
      "feedback_id" => "messi"
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback/messi?version=2018-10-15")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.get_feedback(
      feedback_id: "messi"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_delete_feedback
    message_response = "200"
    stub_request(:delete, "https://gateway.watsonplatform.net/compare-comply/api/v1/feedback/messi?version=2018-10-15")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response, headers: {})

    service_response = service.delete_feedback(
      feedback_id: "messi"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_create_batch
    stub_request(:post, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches?function=tables&version=2018-10-15")
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
    message_response = {
      "batches" => []
    }
    headers = {
      "Content-Type" => "application/json"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches?version=2018-10-15")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response.to_json, headers: headers)

    service_response = service.list_batches
    assert_equal(message_response, service_response.result)
  end

  def test_get_batch
    message_response = "200"
    stub_request(:get, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches/mo?version=2018-10-15")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: message_response, headers: {})

    service_response = service.get_batch(
      batch_id: "mo"
    )
    assert_equal(message_response, service_response.result)
  end

  def test_update_batch
    message_response = "200"
    stub_request(:put, "https://gateway.watsonplatform.net/compare-comply/api/v1/batches/mo?action=goal&version=2018-10-15")
      .with(
        headers: {
          "Accept" => "application/json",
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
