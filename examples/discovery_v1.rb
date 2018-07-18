# frozen_string_literal: true

require("ibm_watson/discovery_v1")
require("json")

# If using IAM
discovery = IBMWatson::DiscoveryV1.new(
  iam_api_key: "IAM API KEY",
  version: "2018-03-05"
)

# If you have username & password in your credentials use:
# discovery = IBMWatson::DiscoveryV1.new(
#   username: "username",
#   password: "password",
#   version: "2018-03-05"
# )

environments = discovery.list_environments.result
puts JSON.pretty_generate(environments)

news_environment_id = "system"

collections = discovery.list_collections(
  environment_id: news_environment_id
).result
news_collections = collections["collections"]
puts JSON.pretty_generate(collections)

configurations = discovery.list_configurations(
  environment_id: news_environment_id
).result
puts JSON.pretty_generate(configurations)

query_results = discovery.query(
  environment_id: news_environment_id,
  collection_id: news_collections[0]["collection_id"],
  filter: "extracted_metadata.sha1::f5*",
  return_fields: "extracted_metadata.sha1"
).result
puts JSON.pretty_generate(query_results)

# new_environment = discovery.create_environment(
#   name: "new env",
#   description: "bogus env"
# ).result
# puts JSON.pretty_generate(new_environment)

# if discovery.get_environment(environment_id: new_environment["environment_id"]).result["status"] == "active"
#   writable_environment_id = new_environment["environment_id"]
#   new_collection = discovery.create_collection(
#     environment_id: writable_environment_id,
#     name: "Example Collection",
#     description: "just a test"
#   ).result

#   puts JSON.pretty_generate(new_collection)
#   puts JSON.pretty_generate(discovery.get_collections(environment_id: writable_environment_id).result)
#   res = discovery.delete_collection(
#     environment_id: "10b733d0-1232-4924-a670-e6ffaed2e641",
#     collection_id: new_collection["collection_id"]
#   ).result
#   puts JSON.pretty_generate(res)
# end

# collections = discovery.list_collections(
#   environment_id: writable_environment_id
# ).result
# puts JSON.pretty_generate(collections)

# File.open(Dir.getwd + "/resources/simple.html") do |file_info|
#   puts JSON.pretty_generate(discovery.test_document(environment_id: writable_environment_id, file: file_info).result)
# end

# File.open(Dir.getwd + "/resources/simple.html") do |file_info|
#   res = discovery.add_document(
#     environment_id: writable_environment_id,
#     collection_id: collections["collections"][0]["collection_id"],
#     file: file_info
#   ).result
#   puts JSON.pretty_generate(res)
# end

# res = discovery.get_collection(
#   environment_id: writable_environment_id,
#   collection_id: collections["collections"][0]["collection_id"]
# ).result
# puts JSON.pretty_generate(res)

# res = discovery.delete_environment(
#   environment_id: writable_environment_id
# ).result
# puts JSON.pretty_generate(res)
