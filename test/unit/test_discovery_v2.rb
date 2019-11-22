# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")
require("stringio")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Discovery V1 Service
class DiscoveryV2Test < Minitest::Test
  include Minitest::Hooks
  attr_accessor :service
  def before_all
    authenticator = IBMWatson::Authenticators::NoAuthAuthenticator.new
    @service = IBMWatson::DiscoveryV2.new(
      version: "2018-03-05",
      authenticator: authenticator
    )
  end

  def test_collections
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/collections?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_collections(
      project_id: "project"
    )
    assert_equal({ "body" => "hello" }, service_response.result)
  end

  def test_query
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/query?version=2018-03-05")
      .with(
        body: "{\"count\":10}",
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.query(
      project_id: "project",
      count: 10
    )
    assert_equal({ "body" => "hello" }, service_response.result)
  end

  def test_get_autocompletion
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/autocompletion?prefix=hi&version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_autocompletion(
      project_id: "project",
      prefix: "hi"
    )
    assert_equal({ "received" => "true" }, service_response.result)
  end

  def test_query_notices
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/notices?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.query_notices(
      project_id: "project"
    )
    assert_equal({ "received" => "true" }, service_response.result)
  end

  def test_list_fields
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/fields?collection_ids=collid&version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_fields(
      project_id: "project",
      collection_ids: ["collid"]
    )
    assert_equal({ "received" => "true" }, service_response.result)
  end

  def test_get_component_settings
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/component_settings?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_component_settings(
      project_id: "project"
    )
    assert_equal({ "received" => "true" }, service_response.result)
  end

  def test_add_document
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/collections/collid/documents?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: [] }.to_json, headers: { "Content-Type" => "application/json" })
    File.open(Dir.getwd + "/resources/simple.html") do |file_info|
      service_response = service.add_document(
        project_id: "project",
        collection_id: "collid",
        file: file_info
      )
      refute(service_response.nil?)
    end
  end

  def test_update_document
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/collections/collid/documents/docid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: [] }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_document(
      project_id: "project",
      collection_id: "collid",
      document_id: "docid",
      file: "file",
      filename: "file.name"
    )
    assert_equal({ "body" => [] }, service_response.result)
  end

  def test_delete_document
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/collections/collid/documents/docid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: [] }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_document(
      project_id: "project",
      collection_id: "collid",
      document_id: "docid"
    )
    assert_equal({ "body" => [] }, service_response.result)
  end

  def test_list_training_queries
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/training_data/queries?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_training_queries(
      project_id: "project"
    )
    assert_equal({ "body" => "hello" }, service_response.result)
  end

  def test_delete_training_queries
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/training_data/queries?version=2018-03-05")
      .with(
        headers: {
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_training_queries(
      project_id: "project"
    )
    assert_nil(service_response)
  end

  def test_create_training_query
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/training_data/queries?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_training_query(
      project_id: "project",
      natural_language_query: "query",
      examples: []
    )
    assert_equal({ "body" => "hello" }, service_response.result)
  end

  def test_get_training_query
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/training_data/queries/queryid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_training_query(
      project_id: "project",
      query_id: "queryid"
    )
    assert_equal({ "body" => "hello" }, service_response.result)
  end

  def test_update_training_query
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v2/projects/project/training_data/queries/queryid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_training_query(
      project_id: "project",
      query_id: "queryid",
      natural_language_query: "query",
      examples: []
    )
    assert_equal({ "body" => "hello" }, service_response.result)
  end
end
