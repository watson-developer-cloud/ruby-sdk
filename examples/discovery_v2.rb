# frozen_string_literal: true

require "json"
require "ibm_watson/authenticators"
require "ibm_watson/discovery_v2"

## Important: Discovery v2 is only available on Cloud Pak for Data. ##

## Authentication ##
## Option 1: username/password
authenticator = IBMWatson::Authenticators::CloudPakForDataAuthenticator.new(
  username: "{username}",
  password: "{password}",
  url: "{authentication_url}",
  disable_ssl: true
)

## Option 2: bearer token
authenticator = IBMWatson::Authenticators::BearerTokenAuthenticator.new(
  bearer_token: "{token}"
)

discovery = IBMWatson::DiscoveryV2.new(
  authenticator: authenticator,
  version: "2019-11-21"
)
discovery.service_url = "{service_url}"
discovery.configure_http_client(disable_ssl_verification: true)

collections = discovery.list_collections(
  project_id: "{project_id}"
).result

puts JSON.pretty_generate(collections)

query_response = discovery.query(
  project_id: "{project_id}",
  count: 10
).result
puts JSON.pretty_generate(query_response)

autocomplete_response = discovery.get_autocompletion(
  project_id: "{project_id}",
  prefix: "hi how are "
)
puts JSON.pretty_generate(autocomplete_response)
