# frozen_string_literal: true

require("json")
require_relative("./../test_helper.rb")
require("webmock/minitest")

WebMock.disable_net_connect!(allow_localhost: true)

# Unit tests for the Visual Recognition V3 Service
class VisualRecognitionV3Test < Minitest::Test
  def test_create_collection
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collection_id" => "bogusnumber",
      "name" => "Dog Breeds",
      "owner" => "58b61352-678c-44d1-9f40-40edf4ea8d19",
      "status" => "passed",
      "created" => "2017-08-25T06:39:01.968Z",
      "classes" => [
        {
          "class" => "goldenretriever"
        }
      ]
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.create_collection
    assert_equal(response, service_response.result)
  end

  def test_list_collections
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collections" => []
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_collections
    assert_equal(response, service_response.result)
  end

  def test_get_collection
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collection_id" => "bogusnumber",
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
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/bogusnumber?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_collection(
      collection_id: "bogusnumber"
    )
    assert_equal(response, service_response.result)
  end

  def test_delete_collection
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {}
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/bogusnumber?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_collection(
      collection_id: "bogusnumber"
    )
    assert_nil(service_response)
  end

  def test_add_images
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collection_id" => "collid"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_images(
      collection_id: "collid"
    )
    assert_equal(response, service_response.result)
  end

  def test_list_images
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collections" => []
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.list_images(
      collection_id: "collid"
    )
    assert_equal(response, service_response.result)
  end

  def test_get_image_details
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collection_id" => "collid"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_image_details(
      collection_id: "collid",
      image_id: "imageid"
    )
    assert_equal(response, service_response.result)
  end

  def test_delete_image
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {}
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_image(
      collection_id: "collid",
      image_id: "imageid"
    )
    assert_nil(service_response)
  end

  def test_get_jpeg_image
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collection_id" => "collid"
    }
    stub_request(:get, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid/jpeg?version=2018-03-19")
      .with(
        headers: {
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.get_jpeg_image(
      collection_id: "collid",
      image_id: "imageid"
    )
    assert_equal(response, service_response.result)
  end

  def test_add_image_training_data
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {
      "collection_id" => "collid"
    }
    stub_request(:post, "https://gateway.watsonplatform.net/visual-recognition/api/v4/collections/collid/images/imageid/training_data?version=2018-03-19")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.add_image_training_data(
      collection_id: "collid",
      image_id: "imageid"
    )
    assert_equal(response, service_response.result)
  end

  def test_delete_user_data
    authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
      bearer_token: "bogus_access_token"
    )
    service = IBMWatson::VisualRecognitionV4.new(
      version: "2018-03-19",
      authenticator: authenticator
    )
    response = {}
    stub_request(:delete, "https://gateway.watsonplatform.net/visual-recognition/api/v4/user_data?version=2018-03-19&customer_id=customer")
      .with(
        headers: {
          "Accept" => "application/json",
          "Host" => "gateway.watsonplatform.net",
          "Authorization" => "Bearer bogus_access_token"
        }
      ).to_return(status: 200, body: response.to_json, headers: { "Content-Type" => "application/json" })
    service_response = service.delete_user_data(
      customer_id: "customer"
    )
    assert_nil(service_response)
  end
end
