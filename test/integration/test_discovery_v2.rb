# frozen_string_literal: true

require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["DISCOVERY_V2_APIKEY"].nil?
  # Integration tests for the Discovery V2 Service
  class DiscoveryV2Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service, :environment_id, :collection_id

    def before_all
      # authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      # bearer_token: ENV["DISCOVERY_V2_TOKEN"]
      # )
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["DISCOVERY_V2_APIKEY"]
      )
      @service = IBMWatson::DiscoveryV2.new(
        authenticator: authenticator,
        version: "2019-11-21"
      )
      @service.service_url = ENV["DISCOVERY_V2_URL"]
      @service.configure_http_client(disable_ssl_verification: true)
      @project_id = ENV["DISCOVERY_V2_PROJECT_ID"]
      @collection_id = ENV["DISCOVERY_V2_COLLECTION_ID"]
      @document_id = nil
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_list_collections
      service_response = service.list_collections(
        project_id: @project_id
      )
      refute(service_response.result["collections"].nil?)
    end

    def test_query
      service_response = service.query(
        project_id: @project_id,
        count: 10
      )
      refute(service_response.result["results"].nil?)
    end

    def test_get_autocompletion
      service_response = service.get_autocompletion(
        project_id: @project_id,
        prefix: "hi how are "
      )
      refute(service_response.result["completions"].nil?)
    end

    def test_query_notices
      service_response = service.query_notices(
        project_id: @project_id
      )
      refute(service_response.result.nil?)
    end

    def test_list_fields
      service_response = service.list_fields(
        project_id: @project_id,
        collection_ids: [@collection_id]
      )
      refute(service_response.result.nil?)
    end

    def test_get_component_settings
      service_response = service.get_component_settings(
        project_id: @project_id
      )
      refute(service_response.result.nil?)
    end

    def test_add_update_delete_document
      File.open(Dir.getwd + "/resources/simple.html") do |file_info|
        service_response = service.add_document(
          project_id: @project_id,
          collection_id: @collection_id,
          file: file_info
        )
        refute(service_response.nil?)
        @document_id = service_response.result["document_id"]
      end
      return if @document_id.nil?

      service_response = service.update_document(
        project_id: @project_id,
        collection_id: @collection_id,
        document_id: @document_id,
        file: "file",
        filename: "file.name"
      )
      refute(service_response.result.nil?)
      service.delete_document(
        project_id: @project_id,
        collection_id: @collection_id,
        document_id: @document_id
      )
    end

    def test_list_training_queries
      service_response = service.list_training_queries(
        project_id: @project_id
      )
      refute(service_response.nil?)
    end

    def test_create_get_update_training_query
      service_response = service.create_training_query(
        project_id: @project_id,
        natural_language_query: "How is the weather today?",
        examples: []
      )
      query_id = service_response.result["query_id"]
      refute(service_response.nil?)

      service_response = service.get_training_query(
        project_id: @project_id,
        query_id: query_id
      )
      refute(service_response.nil?)

      service_response = service.update_training_query(
        project_id: @project_id,
        query_id: query_id,
        natural_language_query: "How is the weather tomorrow?",
        examples: []
      )
      refute(service_response.nil?)
    end

    def test_create_get_update_delete_collection
      service_response = service.create_collection(
        project_id: @project_id,
        name: "ruby_collection"
      )
      create_collection_id = service_response.result["collection_id"]
      assert((200..299).cover?(service_response.status))

      service_response = service.get_collection(
        project_id: @project_id,
        collection_id: create_collection_id
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.update_collection(
        project_id: @project_id,
        collection_id: create_collection_id
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.delete_collection(
        project_id: @project_id,
        collection_id: create_collection_id
      )
      assert(service_response.nil?)
    end

    def test_create_list_get_update_delete_project
      service_response = service.create_project(
        name: "ruby_project"
      )
      create_project_id = service_response.result["project_id"]
      assert((200..299).cover?(service_response.status))

      service_response = service.list_projects
      assert((200..299).cover?(service_response.status))

      service_response = service.get_project(
        project_id: create_project_id
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.update_project(
        project_id: create_project_id
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.delete_project(
        project_id: create_project_id
      )
      assert(service_response.nil?)
    end

    def test_create_list_get_update_delete_enrichment
      enrichment_metadata = {
        name: "RUBY enrichment",
        description: "test dictionary",
        type: "dictionary",
        options: {
          languages: ["en"],
          entity_type: "keyword"
        }
      }

      em_json = JSON[enrichment_metadata]
      enrichment_data = File.open(Dir.getwd + "/resources/test_enrichments.csv")

      service_response = service.create_enrichment(
        project_id: @project_id,
        file: enrichment_data,
        enrichment: em_json
      )
      assert((200..299).cover?(service_response.status))
      create_enrichment_id = service_response.result["enrichment_id"]

      service_response = service.list_enrichments(
        project_id: @project_id
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.get_enrichment(
        project_id: @project_id,
        enrichment_id: create_enrichment_id
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.update_enrichment(
        project_id: @project_id,
        enrichment_id: create_enrichment_id,
        name: "New RUBY Name"
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.delete_enrichment(
        project_id: @project_id,
        enrichment_id: create_enrichment_id
      )
      assert(service_response.nil?)
    end

    def test_delete_user_data
      skip "Covered with the unit test.  No need to run it here"

      service_response = service.delete_user_data(
        customer_id: "000010000"
      )
      assert(service_response.nil?)
    end
  end
else
  class DiscoveryV2Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip discovery integration tests because credentials have not been provided"
    end
  end
end
