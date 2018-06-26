# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Visual Recognition V3 Service
class VisualRecognitionV3Test < Minitest::Test
  def test_get_classifier
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    response = {
      "classifier_id" => "bogusnumber",
      "name" => "Dog Breeds",
      "owner" => "58b61352-678c-44d1-9f40-40edf4ea8d19",
      "status" => "failed",
      "created" => "2017-08-25T06:39:01.968Z",
      "classes" => [
        {
          "class" => "goldenretriever"
        }
      ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v3/classifiers/bogusnumber?api_key=bogusapikey&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_classifier(
      classifier_id: "bogusnumber"
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_classifier
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v3/classifiers/bogusnumber?api_key=bogusapikey&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: { "response" => 200 }.to_json, headers: { "Content-Type" => "applicaton/json" })
    service_response = service.delete_classifier(
      classifier_id: "bogusnumber"
    )
    assert_nil(service_response)
  end

  def test_list_classifiers
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    response = {
      "classifiers" =>
        [
          {
            "classifier_id" => "InsuranceClaims_1362331461",
            "name" => "Insurance Claims",
            "status" => "ready"
          },
          {
            "classifier_id" => "DogBreeds_1539707331",
            "name" => "Dog Breeds",
            "status" => "ready"
          }
        ]
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v3/classifiers?api_key=bogusapikey&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_classifiers
    assert_equal(response, service_response.body)
  end

  def test_create_classifier
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    response = {
      "classifier_id" => "DogBreeds_2014254824",
      "name" => "Dog Breeds",
      "owner" => "58b61352-678c-44d1-9f40-40edf4ea8d19",
      "status" => "failed",
      "created" => "2017-08-25T06:39:01.968Z",
      "classes" => [{ "class" => "goldenretriever" }]
    }
    cars = File.open(Dir.getwd + "/resources/cars.zip")
    trucks = File.open(Dir.getwd + "/resources/trucks.zip")

    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v3/classifiers?api_key=bogusapikey&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_classifier(
      name: "Cars vs Trucks",
      classname_positive_examples: cars,
      negative_examples: trucks
    )
    assert_equal(response, service_response.body)
  end

  def test_update_classifier
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    response = {
      "classifier_id" => "bogusid",
      "name" => "Insurance Claims",
      "owner" => "58b61352-678c-44d1-9f40-40edf4ea8d19",
      "status" => "ready",
      "created" => "2017-07-17T22:17:14.860Z",
      "classes" => [
        { "class" => "motorcycleaccident" },
        { "class" => "flattire" },
        { "class" => "brokenwinshield" }
      ]
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v3/classifiers/bogusid?api_key=bogusapikey&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Content-Type" => "application/x-www-form-urlencoded",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.update_classifier(
      classifier_id: "bogusid"
    )
    assert_equal(response, service_response.body)
  end

  def test_classify
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    response = {
      "images" =>
        [
          {
            "image" => "test.jpg",
            "classifiers" =>
              [
                {
                  "classes" =>
                  [
                    { "score" => 0.95, "class" => "tiger", "type_hierarchy" => "/animal/mammal/carnivore/feline/big cat/tiger" },
                    { "score" => 0.997, "class" => "big cat" },
                    { "score" => 0.998, "class" => "feline" },
                    { "score" => 0.998, "class" => "carnivore" },
                    { "score" => 0.998, "class" => "mammal" },
                    { "score" => 0.999, "class" => "animal" }
                  ],
                  "classifier_id" => "default",
                  "name" => "default"
                }
              ]
          }
        ],
      "custom_classes" => 0,
      "images_processed" => 1
    }

    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v3/classify?api_key=bogusapikey&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.classify(
      url: "http://google.com"
    )
    assert_equal(response, service_response.body)

    service_response = service.classify(
      url: "http://google.com",
      classifier_ids: %w[one two three]
    )
    assert_equal(response, service_response.body)

    service_response = service.classify(
      url: "http://google.com",
      owners: %w[me IBM]
    )
    assert_equal(response, service_response.body)

    image_file = File.open(Dir.getwd + "/resources/test.jpg")
    service_response = service.classify(
      images_file: image_file
    )
    assert_equal(response, service_response.body)
  end

  def test_detect_faces
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    response = {
      "images" => [
        {
          "faces" => [
            {
              "age" => {
                "max" => 44,
                "min" => 35,
                "score" => 0.446989
              },
              "face_location" => {
                "height" => 159,
                "left" => 256,
                "top" => 64,
                "width" => 92
              },
              "gender" => {
                "gender" => "MALE",
                "score" => 0.99593
              },
              "identity" => {
                "name" => "Barack Obama",
                "score" => 0.970688,
                "type_hierarchy" => "/people/politicians/democrats/barack obama"
              }
            }
          ],
          "resolved_url" => "https://watson-developer-cloud.github.io/doc-tutorial-downloads/visual-recognition/prez.jpg",
          "source_url" => "https://watson-developer-cloud.github.io/doc-tutorial-downloads/visual-recognition/prez.jpg"
        }
      ],
      "images_processed" => 1
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v3/detect_faces?api_key=bogusapikey&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.detect_faces(
      url: "http://google.com"
    )
    assert_equal(response, service_response.body)

    image_file = File.open(Dir.getwd + "/resources/test.jpg")
    service_response = service.detect_faces(
      images_file: image_file
    )
    assert_equal(response, service_response.body)
  end

  def test_delete_user_data
    service = WatsonDeveloperCloud::VisualRecognitionV3.new(
      version: "2018-03-19",
      api_key: "bogusapikey"
    )
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v3/user_data?api_key=bogusapikey&customer_id=id&version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net"
        }
      ).to_return(status: 200, body: "", headers: {})
    service_response = service.delete_user_data(
      customer_id: "id"
    )
    assert_nil(service_response)
  end
end
