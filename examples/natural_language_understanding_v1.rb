# frozen_string_literal: true

require "json"
require "ibm_watson/authenticators"
require "ibm_watson/natural_language_understanding_v1"

# If using IAM
authenticator = IBMWatson::Authenticators::IamAuthenticator.new(
  apikey: "{iam_api_key}"
)

# If you have username & password in your credentials use:
# authenticator = IBMWatson::Authenticators::BasicAuthenticator.new(
#   username: "{username}",
#   password: "{password}"
# )

natural_language_understanding = IBMWatson::NaturalLanguageUnderstandingV1.new(
  authenticator: authenticator,
  version: "2018-03-16"
)
natural_language_understanding.service_url = "{service_url}"

# If you have username & password in your credentials use:
# natural_language_understanding = IBMWatson::NaturalLanguageUnderstandingV1.new(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD",
#   version: "2018-03-16"
# )

response = natural_language_understanding.analyze(
  text: "Bruce Banner is the Hulk and Bruce Wayne is BATMAN! " \
        "Superman fears not Banner, but Wayne",
  features: {
    "entities" => {},
    "keywords" => {}
  }
).result
puts JSON.pretty_generate(response)
