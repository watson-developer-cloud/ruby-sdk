# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")

if !ENV["NATURAL_LANGUAGE_UNDERSTANDING_APIKEY"].nil? && !ENV["NATURAL_LANGUAGE_UNDERSTANDING_URL"].nil?
  # Integration tests for the Natural Language Understanding V1 Service
  class NaturalLanguageUnderstandingV1Test < Minitest::Test
    include Minitest::Hooks
    attr_accessor :service
    def before_all
      authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
        apikey: ENV["NATURAL_LANGUAGE_UNDERSTANDING_APIKEY"]
      )
      @service = IBMWatson::NaturalLanguageUnderstandingV1.new(
        version: "2018-03-16",
        authenticator: authenticator,
        url: ENV["NATURAL_LANGUAGE_UNDERSTANDING_URL"]
      )
      @service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
    end

    def test_text_analyze
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      text = "IBM is an American multinational technology company "
      text += "headquartered in Armonk, New York, United States, "
      text += "with operations in over 170 countries."
      service_response = service.analyze(
        features: {
          entities: {
            emotion: true,
            sentiment: true,
            limit: 2
          },
          keywords: {
            emotion: true,
            sentiment: true,
            limit: 2
          }
        },
        text: text
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_html_analyze
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.analyze(
        features: {
          sentiment: {}
        },
        html: "<span>hello this is a test </span>"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_url_analyze
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.analyze(
        features: {
          categories: {}
        },
        url: "www.ibm.com"
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_list_models
      # skip
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.list_models
      assert((200..299).cover?(service_response.status))
    end

    def test_check_orphands
      skip "Use to help delete old models"
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      service_response = service.list_sentiment_models
      puts JSON.pretty_generate(service_response.result)
      service_response = service.list_categories_models
      puts JSON.pretty_generate(service_response.result)
      service_response = service.list_classifications_models
      puts JSON.pretty_generate(service_response.result)

      # service.delete_sentiment_model(model_id: "model_id1")
      # service.delete_categories_model(model_id: "0122b971-94c9-4468-a98f-930f4ce28c32")
      # service.delete_classifications_model(model_id: "0122b971-94c9-4468-a98f-930f4ce28c32")
    end

    def test_sentiment_models
      # skip "test_sentiment_models"
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      training_data = File.open(Dir.getwd + "/resources/nlu_sentiment_data.csv")
      service_response = service.create_sentiment_model(
        language: "en",
        training_data: training_data
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.list_sentiment_models
      model_id = service_response.result["models"][0]["model_id"]
      assert((200..299).cover?(service_response.status))

      service_response = service.get_sentiment_model(model_id: model_id)
      assert((200..299).cover?(service_response.status))

      service_response = service.update_sentiment_model(
        model_id: model_id,
        language: "en",
        training_data: training_data
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.delete_sentiment_model(
        model_id: model_id
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_categories_models
      # skip "test_categories_models"
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      training_data = File.open(Dir.getwd + "/resources/nlu_categories_training.json")
      service_response = service.create_categories_model(
        language: "en",
        training_data: training_data,
        training_data_content_type: "application/json"
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.list_categories_models
      model_id = service_response.result["models"][0]["model_id"]
      assert((200..299).cover?(service_response.status))
      # puts JSON.pretty_generate(service_response.result)
      # puts JSON.pretty_generate(model_id)

      service_response = service.get_categories_model(model_id: model_id)
      assert((200..299).cover?(service_response.status))

      service_response = service.update_categories_model(
        model_id: model_id,
        language: "en",
        training_data: training_data,
        training_data_content_type: "application/json"
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.delete_categories_model(
        model_id: model_id
      )
      assert((200..299).cover?(service_response.status))
    end

    def test_classifications_models
      # skip "test_classifications_models"
      service.add_default_headers(
        headers: {
          "X-Watson-Learning-Opt-Out" => "1",
          "X-Watson-Test" => "1"
        }
      )
      training_data = File.open(Dir.getwd + "/resources/nlu_classifications_training.json")
      service_response = service.create_classifications_model(
        language: "en",
        training_data: training_data,
        training_data_content_type: "application/json"
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.list_classifications_models
      model_id = service_response.result["models"][0]["model_id"]
      assert((200..299).cover?(service_response.status))
      # puts JSON.pretty_generate(service_response.result)
      # puts JSON.pretty_generate(model_id)

      service_response = service.get_classifications_model(model_id: model_id)
      assert((200..299).cover?(service_response.status))

      service_response = service.update_classifications_model(
        model_id: model_id,
        language: "en",
        training_data: training_data,
        training_data_content_type: "application/json"
      )
      assert((200..299).cover?(service_response.status))

      service_response = service.delete_classifications_model(
        model_id: model_id
      )
      assert((200..299).cover?(service_response.status))
    end
  end
else
  class NaturalLanguageUnderstandingV1Test < Minitest::Test
    def test_missing_credentials_skip_integration
      skip "Skip natural language understanding integration tests because credentials have not been provided"
    end
  end
end
