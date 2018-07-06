# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")
require("stringio")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Discovery V1 Service
class DiscoveryV1Test < Minitest::Test
  def test_environments
    discovery_response_body = {
      "environments" => [
        {
          "environment_id" => "string",
          "name" => "envname",
          "description" => "",
          "created" => "2016-11-20T01:03:17.645Z",
          "updated" => "2016-11-20T01:03:17.645Z",
          "status" => "status",
          "index_capacity" => {
            "disk_usage" => {
              "used_bytes" => 0,
              "total_bytes" => 0,
              "used" => "string",
              "total" => "string",
              "percent_used" => 0
            },
            "memory_usage" => {
              "used_bytes" => 0,
              "total_bytes" => 0,
              "used" => "string",
              "total" => "string",
              "percent_used" => 0
            }
          }
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: discovery_response_body.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.list_environments
    assert_equal(discovery_response_body, service_response.body)
  end

  def test_get_environment
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "resulting_key" => true }.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.get_environment(
      environment_id: "envid"
    )
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_create_environment
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments?version=2018-03-05")
      .with(
        body: "{\"name\":\"my name\",\"description\":\"my description\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "resulting_key" => true }.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.create_environment(
      name: "my name",
      description: "my description"
    )
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_update_environment
    stub_request(:put, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid?version=2018-03-05")
      .with(
        body: "{\"name\":\"hello\",\"description\":\"new\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "resulting_key" => true }.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.update_environment(
      environment_id: "envid",
      name: "hello",
      description: "new"
    )
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_delete_environment
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "resulting_key" => true }.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.delete_environment(
      environment_id: "envid"
    )
    assert_equal({ "resulting_key" => true }, service_response.body)
  end

  def test_collections
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.list_collections(
      environment_id: "envid"
    )
    assert_equal({ "body" => "hello" }, service_response.body)
  end

  def test_collection
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections?version=2018-03-05")
      .with(
        body: "{\"name\":\"name\",\"description\":\"\",\"configuration_id\":\"confid\",\"language\":\"\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "create" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_collection(
      environment_id: "envid",
      name: "name",
      description: "",
      language: "",
      configuration_id: "confid"
    )
    assert_equal({ "body" => "create" }, service_response.body)

    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections?version=2018-03-05")
      .with(
        body: "{\"name\":\"name\",\"description\":\"\",\"language\":\"es\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "body" => "create" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_collection(
      environment_id: "envid",
      name: "name",
      language: "es",
      description: ""
    )
    assert_equal({ "body" => "create" }, service_response.body)

    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_collection(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_equal({ "body" => "hello" }, service_response.body)

    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_collection(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_equal({ "body" => "hello" }, service_response.body)

    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/fields?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_collection_fields(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_equal({ "body" => "hello" }, service_response.body)
  end

  def test_query
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/query?count=10&version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.query(
      environment_id: "envid",
      collection_id: "collid",
      count: 10
    )
    assert_equal({ "body" => "hello" }, service_response.body)
  end

  def test_query_relations
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/query_relations?version=2018-03-05")
      .with(
        body: "{\"count\":10}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.query_relations(
      environment_id: "envid",
      collection_id: "collid",
      count: 10
    )
    assert_equal({ "body" => "hello" }, service_response.body)
  end

  def test_query_entities
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/query_entities?version=2018-03-05")
      .with(
        body: "{\"count\":10}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: "hello" }.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.query_entities(
      environment_id: "envid",
      collection_id: "collid",
      count: 10
    )
    assert_equal({ "body" => "hello" }, service_response.body)
  end

  def test_configs
    results = {
      "configurations" => [
        {
          "name" => "Default Configuration",
          "configuration_id" => "confid"
        }
      ]
    }
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/configurations?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: results.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_configurations(
      environment_id: "envid"
    )
    assert_equal(results, service_response.body)

    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/configurations/confid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: results["configurations"][0].to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_configuration(
      environment_id: "envid",
      configuration_id: "confid"
    )
    assert_equal(results["configurations"][0], service_response.body)

    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/configurations?version=2018-03-05")
      .with(
        body: "{\"name\":\"my name\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: results["configurations"][0].to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_configuration(
      environment_id: "envid",
      name: "my name"
    )
    assert_equal(results["configurations"][0], service_response.body)

    stub_request(:put, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/configurations/confid?version=2018-03-05")
      .with(
        body: "{\"name\":\"my new name\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: results["configurations"][0].to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_configuration(
      environment_id: "envid",
      configuration_id: "confid",
      name: "my new name"
    )
    assert_equal(results["configurations"][0], service_response.body)

    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/configurations/confid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "deleted" => "bogus -- ok" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_configuration(
      environment_id: "envid",
      configuration_id: "confid"
    )
    assert_equal({ "deleted" => "bogus -- ok" }, service_response.body)
  end

  def test_document
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/preview?configuration_id=bogus&version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { configurations: [] }.to_json, headers: { "Content-Type" => "application/json" })
    File.open(Dir.getwd + "/resources/simple.html") do |file_info|
      service_response = service.test_configuration_in_environment(
        environment_id: "envid",
        configuration_id: "bogus",
        file: file_info,
        filename: "simple.html"
      )
      refute(service_response.nil?)

      service_response = service.test_configuration_in_environment(
        environment_id: "envid",
        configuration_id: "bogus",
        file: "file_info"
      )
      refute(service_response.nil?)

      stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/preview?version=2018-03-05")
        .with(
          headers: {
            "Accept" => "application/json",
            "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
            "Host" => "gateway.watsonplatform.net"
          }
        ).to_return(status: 200, body: { configurations: [] }.to_json, headers: { "Content-Type" => "application/json" })
      service_response = service.test_configuration_in_environment(
        environment_id: "envid",
        file: file_info
      )
      refute(service_response.nil?)
    end
    doc_status = {
      "document_id" => "45556e23-f2b1-449d-8f27-489b514000ff",
      "configuration_id" => "2e079259-7dd2-40a9-998f-3e716f5a7b88",
      "created" => "2016-06-16T10:56:54.957Z",
      "updated" => "2017-05-16T13:56:54.957Z",
      "status" => "available",
      "status_description" => "Document is successfully ingested and indexed with no warnings",
      "notices" => []
    }
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/documents?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: [] }.to_json, headers: { "Content-Type" => "application/json" })
    File.open(Dir.getwd + "/resources/simple.html") do |file_info|
      service_response = service.add_document(
        environment_id: "envid",
        collection_id: "collid",
        file: file_info
      )
      refute(service_response.nil?)
    end
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/documents/docid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: doc_status.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_document_status(
      environment_id: "envid",
      collection_id: "collid",
      document_id: "docid"
    )
    assert_equal(doc_status, service_response.body)

    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/documents/docid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: [] }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_document(
      environment_id: "envid",
      collection_id: "collid",
      document_id: "docid",
      file: "file",
      filename: "file.name"
    )
    assert_equal({ "body" => [] }, service_response.body)

    service_response = service.update_document(
      environment_id: "envid",
      collection_id: "collid",
      document_id: "docid",
      file: "file"
    )
    assert_equal({ "body" => [] }, service_response.body)

    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/documents/docid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { body: [] }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_document(
      environment_id: "envid",
      collection_id: "collid",
      document_id: "docid"
    )
    assert_equal({ "body" => [] }, service_response.body)

    service_response = service.add_document(
      environment_id: "envid",
      collection_id: "collid",
      file: "my string of file",
      filename: "file.txt"
    )
    refute(service_response.nil?)

    service_response = service.add_document(
      environment_id: "envid",
      collection_id: "collid",
      file: StringIO.new("<h1>my string of file</h1>"),
      filename: "file.html",
      file_content_type: "application/html"
    )
    refute(service_response.nil?)

    service_response = service.add_document(
      environment_id: "envid",
      collection_id: "collid",
      file: StringIO.new("<h1>my string of file</h1>"),
      filename: "file.html",
      file_content_type: "application/html",
      metadata: StringIO.new({ stuff: "woot!" }.to_json)
    )
    refute(service_response.nil?)
  end

  def test_delete_all_training_data
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 204, body: "", headers: {})
    service_response = service.delete_all_training_data(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_nil(service_response)
  end

  def test_list_training_data
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    mock_response = {
      "environment_id" => "string",
      "collection_id" => "string",
      "queries" => [
        {
          "query_id" => "string",
          "natural_language_query" => "string",
          "filter" => "string",
          "examples" => [
            {
              "document_id" => "string",
              "cross_reference" => "string",
              "relevance" => 0
            }
          ]
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: mock_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_training_data(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_equal(mock_response, service_response.body)
  end

  def test_add_training_data
    natural_language_query = "why is the sky blue"
    filter = "text:meteorology"
    examples = [
      {
        "document_id" => "54f95ac0-3e4f-4756-bea6-7a67b2713c81",
        "relevance" => 1
      },
      {
        "document_id" => "01bcca32-7300-4c9f-8d32-33ed7ea643da",
        "cross_reference" => "my_id_field:1463",
        "relevance" => 5
      }
    ]
    mock_response = {
      "query_id" => "string",
      "natural_language_query" => "string",
      "filter" => "string",
      "examples" => [
        {
          "document_id" => "string",
          "cross_reference" => "string",
          "relevance" => 0
        }
      ]
    }
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data?version=2018-03-05")
      .with(
        body: "{\"natural_language_query\":\"why is the sky blue\",\"filter\":\"text:meteorology\",\"examples\":[{\"document_id\":\"54f95ac0-3e4f-4756-bea6-7a67b2713c81\",\"relevance\":1},{\"document_id\":\"01bcca32-7300-4c9f-8d32-33ed7ea643da\",\"cross_reference\":\"my_id_field:1463\",\"relevance\":5}]}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: mock_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_training_data(
      environment_id: "envid",
      collection_id: "collid",
      natural_language_query: natural_language_query,
      filter: filter,
      examples: examples
    )
    assert_equal(mock_response, service_response.body)
  end

  def test_delete_training_data
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data/queryid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_training_data(
      environment_id: "envid",
      collection_id: "collid",
      query_id: "queryid"
    )
    assert_nil(service_response)
  end

  def test_get_training_data
    mock_response = {
      "query_id" => "string",
      "natural_language_query" => "string",
      "filter" => "string",
      "examples" => [
        {
          "document_id" => "string",
          "cross_reference" => "string",
          "relevance" => 0
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data/queryid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: mock_response.to_json, headers: { "Content-Type" => "application/json" })
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    service_response = service.get_training_data(
      environment_id: "envid",
      collection_id: "collid",
      query_id: "queryid"
    )
    assert_equal(mock_response, service_response.body)
  end

  def test_create_training_example
    document_id = "string"
    relevance = 0
    cross_reference = "string"
    mock_response = {
      "document_id" => "string",
      "cross_reference" => "string",
      "relevance" => 0
    }
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data/queryid/examples?version=2018-03-05")
      .with(
        body: "{\"document_id\":\"string\",\"cross_reference\":\"string\",\"relevance\":0}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: mock_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_training_example(
      environment_id: "envid",
      collection_id: "collid",
      query_id: "queryid",
      document_id: document_id,
      relevance: relevance,
      cross_reference: cross_reference
    )
    assert_equal(mock_response, service_response.body)
  end

  def test_delete_training_example
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data/queryid/examples/exampleid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 204, body: "", headers: {})
    service_response = service.delete_training_example(
      environment_id: "envid",
      collection_id: "collid",
      query_id: "queryid",
      example_id: "exampleid"
    )
    assert_nil(service_response)
  end

  def test_get_training_example
    mock_response = {
      "document_id" => "string",
      "cross_reference" => "string",
      "relevance" => 0
    }
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data/queryid/examples/exampleid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: mock_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_training_example(
      environment_id: "envid",
      collection_id: "collid",
      query_id: "queryid",
      example_id: "exampleid"
    )
    assert_equal(mock_response, service_response.body)
  end

  def test_update_training_example
    relevance = 0
    cross_reference = "string"
    mock_response = {
      "document_id" => "string",
      "cross_reference" => "string",
      "relevance" => 0
    }
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:put, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data/queryid/examples/exampleid?version=2018-03-05")
      .with(
        body: "{\"cross_reference\":\"string\",\"relevance\":0}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: mock_response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_training_example(
      environment_id: "envid",
      collection_id: "collid",
      query_id: "queryid",
      example_id: "exampleid",
      relevance: relevance,
      cross_reference: cross_reference
    )
    assert_equal(mock_response, service_response.body)
  end

  def test_expansions
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/expansions?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { expansions: "results" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_expansions(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_equal({ "expansions" => "results" }, service_response.body)

    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/expansions?version=2018-03-05")
      .with(
        body: "{\"expansions\":[{\"input_terms\":\"dumb\",\"expanded_terms\":\"dumb2\"}]}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { expansions: "success" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_expansions(
      environment_id: "envid",
      collection_id: "collid",
      expansions: [
        {
          "input_terms" => "dumb",
          "expanded_terms" => "dumb2"
        }
      ]
    )
    assert_equal({ "expansions" => "success" }, service_response.body)

    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/expansions?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { description: "success" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_expansions(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_nil(service_response)
  end

  def test_delete_user_data
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/user_data?customer_id=id&version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_user_data(
      customer_id: "id"
    )
    assert_nil(service_response)
  end

  def test_query_notices
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/notices?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.query_notices(
      environment_id: "envid",
      collection_id: "collid"
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_federated_query
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/query?collection_ids=collid&version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.federated_query(
      environment_id: "envid",
      collection_ids: ["collid"]
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_federated_query_notices
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/notices?collection_ids=collid&version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.federated_query_notices(
      environment_id: "envid",
      collection_ids: ["collid"]
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_list_training_examples
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid/training_data/queryid/examples?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_training_examples(
      environment_id: "envid",
      collection_id: "collid",
      query_id: "queryid"
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_list_credentials
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/credentials?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_credentials(
      environment_id: "envid"
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_create_credentials
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:post, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/credentials?version=2018-03-05")
      .with(
        body: "{\"source_type\":\"salesforce\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_credentials(
      environment_id: "envid",
      source_type: "salesforce"
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_get_credentials
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:get, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/credentials/credid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_credentials(
      environment_id: "envid",
      credential_id: "credid"
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_update_credentials
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:put, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/credentials/credid?version=2018-03-05")
      .with(
        body: "{\"source_type\":\"salesforce\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "received" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_credentials(
      environment_id: "envid",
      credential_id: "credid",
      source_type: "salesforce"
    )
    assert_equal({ "received" => "true" }, service_response.body)
  end

  def test_delete_credentials
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/credentials/credid?version=2018-03-05")
      .with(
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "deleted" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_credentials(
      environment_id: "envid",
      credential_id: "credid"
    )
    assert_equal({ "deleted" => "true" }, service_response.body)
  end

  def test_update_collection
    service = WatsonAPIs::DiscoveryV1.new(
      username: "username",
      password: "password",
      version: "2018-03-05"
    )
    stub_request(:put, "https://gateway.watsonplatform.net/discovery/api/v1/environments/envid/collections/collid?version=2018-03-05")
      .with(
        body: "{\"name\":\"name\",\"description\":\"updated description\"}",
        headers: {
          "Accept" => "application/json",
          "Authorization" => "Basic dXNlcm5hbWU6cGFzc3dvcmQ=",
          "Content-Type" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "updated" => "true" }.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_collection(
      environment_id: "envid",
      collection_id: "collid",
      name: "name",
      description: "updated description"
    )
    assert_equal({ "updated" => "true" }, service_response.body)
  end
end
