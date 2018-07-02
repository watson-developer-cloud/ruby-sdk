require("watson_apis/discovery_v1")

discovery = WatsonAPIs::DiscoveryV1.new(
  version: "2018-03-05",
  username: "username",
  password: "password"
)

environments = discovery.list_environments.body
p environments

news_environment_id = "system"

collections = discovery.list_collections(
  environment_id: news_environment_id
).body
news_collections = collections["collections"]
p collections

configurations = discovery.list_configurations(
  environment_id: news_environment_id
).body
p configurations

query_results = discovery.query(
  environment_id: news_environment_id,
  collection_id: news_collections[0]["collection_id"],
  filter: "extracted_metadata.sha1::f5*",
  return_fields: "extracted_metadata.sha1"
).body
p query_results

# new_environment = discovery.create_environment(
#   name: "new env",
#   description: "bogus env"
# ).body
# p new_environment

# if discovery.get_environment(environment_id: new_environment["environment_id"]).body["status"] == "active"
#   writable_environment_id = new_environment["environment_id"]
#   new_collection = discovery.create_collection(
#     environment_id: writable_environment_id,
#     name: "Example Collection",
#     description: "just a test"
#   ).body

#   p new_collection
#   p discovery.get_collections(environment_id: writable_environment_id).body
#   res = discovery.delete_collection(
#     environment_id: "10b733d0-1232-4924-a670-e6ffaed2e641",
#     collection_id: new_collection["collection_id"]
#   ).body
#   p res
# end

# collections = discovery.list_collections(
#   environment_id: writable_environment_id
# ).body
# p collections

# File.open(Dir.getwd + "/resources/simple.html") do |file_info|
#   p discovery.test_document(environment_id: writable_environment_id, file: file_info)
# end

# File.open(Dir.getwd + "/resources/simple.html") do |file_info|
#   res = discovery.add_document(
#     environment_id: writable_environment_id,
#     collection_id: collections["collections"][0]["collection_id"],
#     file: file_info
#   ).body
#   p res
# end

# res = discovery.get_collection(
#   environment_id: writable_environment_id,
#   collection_id: collections["collections"][0]["collection_id"]
# ).body
# p res["document_counts"]

# res = discovery.delete_environment(
#   environment_id: writable_environment_id
# ).body
# p res
