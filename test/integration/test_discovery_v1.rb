# frozen_string_literal: true

require_relative("./../test_helper.rb")
require("minitest/hooks/test")

if !ENV["DISCOVERY_APIKEY"].nil? && !ENV["DISCOVERY_URL"].nil?
  # Integration tests for the Discovery V1 Service
  class DiscoveryV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service, :environment_id, :collection_id

    def before_all
      authenticator = IBMCloudSdkCore::IamAuthenticator.new(
        apikey: ENV["DISCOVERY_APIKEY"]
      )
      @service = IBMWatson::DiscoveryV1.new(
        authenticator: authenticator,
        url: ENV["DISCOVERY_URL"],
        version: "2018-03-05"
      )
      @environment_id = ENV["DISCOVERY_ENVIRONMENT_ID"]
      @collection_id = ENV["DISCOVERY_COLLECTION_ID"]
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_environments
      envs = @service.list_environments.result
      refute(envs.nil?)
      env = @service.get_environment(
        environment_id: envs["environments"][0]["environment_id"]
      )
      refute(env.nil?)
    end

    def test_configurations
      configs = @service.list_configurations(
        environment_id: @environment_id
      ).result
      refute(configs.nil?)

      skip "Skip to allow for concurrent travis jobs"
      name = "test" + ("A".."Z").to_a.sample
      new_configuration_id = @service.create_configuration(
        environment_id: @environment_id,
        name: name,
        description: "creating new config for ruby sdk"
      ).result
      new_configuration_id = new_configuration_id["configuration_id"]
      refute(new_configuration_id.nil?)
      @service.get_configuration(
        environment_id: @environment_id,
        configuration_id: new_configuration_id
      )

      updated_config = @service.update_configuration(
        environment_id: @environment_id,
        configuration_id: new_configuration_id,
        name: "lala"
      ).result
      updated_config = updated_config
      assert_equal("lala", updated_config["name"])

      deleted_config = @service.delete_configuration(
        environment_id: @environment_id,
        configuration_id: new_configuration_id
      ).result
      deleted_config = deleted_config
      assert_equal("deleted", deleted_config["status"])
    end

    def test_collections_fields_query_and_expansions
      skip "Time consuming"
      name = "Example collection for ruby" + ("A".."Z").to_a.sample
      new_collection_id = @service.create_collection(
        environment_id: @environment_id,
        name: name,
        description: "Integration test for ruby sdk"
      ).result
      new_collection_id = new_collection_id["collection_id"]
      refute(new_collection_id.nil?)

      collection_status = { "status" => "pending" }
      while collection_status["status"] == "pending"
        sleep(1)
        collection_status = @service.get_collection(
          environment_id: @environment_id,
          collection_id: new_collection_id
        ).result
        collection_status = collection_status
      end
      updated_collection = @service.update_collection(
        environment_id: @environment_id,
        collection_id: new_collection_id,
        name: name,
        description: "Updating description"
      ).result
      updated_collection = updated_collection
      assert_equal("Updating description", updated_collection["description"])

      fields = @service.list_fields(
        environment_id: @environment_id,
        collection_ids: [new_collection_id]
      )
      refute(fields.nil?)

      query_results = @service.query(
        environment_id: @environment_id,
        collection_id: new_collection_id,
        filter: "extracted_metadata.sha1::9181d244*",
        return_fields: "extracted_metadata.sha1"
      ).result
      refute(query_results.nil?)

      @service.create_expansions(
        environment_id: @environment_id,
        collection_id: new_collection_id,
        expansions: [
          {
            "input_terms" => ["a"],
            "expanded_terms" => ["aa"]
          }
        ]
      )
      expansions = @service.list_expansions(
        environment_id: @environment_id,
        collection_id: new_collection_id
      ).result
      expansions = expansions
      refute(expansions["expansions"].nil?)

      @service.delete_expansions(
        environment_id: @environment_id,
        collection_id: new_collection_id
      )
      deleted_collection = @service.delete_collection(
        environment_id: @environment_id,
        collection_id: new_collection_id
      ).result
      deleted_collection = deleted_collection
      assert_equal("deleted", deleted_collection["status"])
    end

    def test_documents
      skip "Time consuming"
      add_doc = nil
      File.open(Dir.getwd + "/resources/simple.html") do |file_info|
        add_doc = @service.add_document(
          environment_id: @environment_id,
          collection_id: @collection_id,
          file: file_info
        ).result
      end
      add_doc = add_doc
      refute(add_doc["document_id"].nil?)

      doc_status = { "status" => "processing" }
      while doc_status["status"] == "processing"
        sleep(1)
        doc_status = @service.get_document_status(
          environment_id: @environment_id,
          collection_id: @collection_id,
          document_id: add_doc["document_id"]
        ).result
        doc_status = doc_status
      end
      assert_equal("available", doc_status["status"])

      update_doc = nil
      File.open(Dir.getwd + "/resources/simple.html") do |file_info|
        update_doc = @service.update_document(
          environment_id: @environment_id,
          collection_id: @collection_id,
          document_id: add_doc["document_id"],
          file: file_info,
          filename: "newname.html"
        ).result
      end
      refute(update_doc.nil?)

      doc_status = { "status" => "processing" }
      while doc_status["status"] == "processing"
        sleep(1)
        doc_status = @service.get_document_status(
          environment_id: @environment_id,
          collection_id: @collection_id,
          document_id: add_doc["document_id"]
        ).result
        doc_status = doc_status
      end
      assert_equal("available", doc_status["status"])

      delete_doc = @service.delete_document(
        environment_id: @environment_id,
        collection_id: @collection_id,
        document_id: add_doc["document_id"]
      ).result
      delete_doc = delete_doc
      assert_equal("deleted", delete_doc["status"])
    end

    # def test_queries
    # end

    def test_list_credentials
      credentials = @service.list_credentials(
        environment_id: @environment_id
      ).result
      refute(credentials.nil?)
    end

    def test_list_gateways
      response = @service.list_gateways(
        environment_id: @environment_id
      ).result
      refute(response.nil?)
    end

    def test_create_get_delete_gateways
      skip
      gateway = @service.create_gateway(
        environment_id: @environment_id,
        name: "test"
      ).result
      refute(gateway.nil?)

      response = @service.get_gateway(
        environment_id: @environment_id,
        gateway_id: gateway["gateway_id"]
      ).result
      refute(response.nil?)

      response = @service.delete_gateway(
        environment_id: @environment_id,
        gateway_id: gateway["gateway_id"]
      ).result
      refute(response.nil?)
    end
  end
else
  class DiscoveryV1Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip discovery integration tests because credentials have not been provided"
    end
  end
end
