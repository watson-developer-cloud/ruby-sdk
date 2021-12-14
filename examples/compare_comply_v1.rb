# frozen_string_literal: true

require "json"
require "ibm_watson/authenticators"
require "ibm_watson/compare_comply_v1"

# If using IAM
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "{iam_api_key}"
)

# If you have username & password in your credentials use:
# authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
#   username: "{username}",
#   password: "{password}"
# )

compare_comply = IBMWatson::CompareComplyV1.new(
  version: "2019-09-16",
  authenticator: authenticator
)
compare_comply.service_url = "{service_url}"

puts JSON.pretty_generate(compare_comply.list_feedback.result)
