# frozen_string_literal: true

require("ibm_watson/tone_analyzer_v3")
require("json")

# If using IAM
tone_analyzer = ToneAnalyzerV3(
  iam_api_key: "IAM API KEY",
  version: "2017-09-21"
)

# If you have username & password in your credentials use:
# tone_analyzer = ToneAnalyzerV3(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD",
#   version: "2017-09-21"
# )

utterances = [
  {
    "text" => "I am very happy.",
    "user" => "glenn"
  },
  {
    "text" => "It is a good day.",
    "user" => "glenn"
  }
]
p "\ntone_chat example 1:\n"
p tone_analyzer.tone_chat(utterances: utterances).result

p "\ntone example 1:\n"
p tone_analyzer.tone(
  tone_input: "I am very happy. It is a good day.",
  content_type: "text/plain"
).result

p "\ntone example 2:\n"
File.open(Dir.getwd + "/resources/tone-example.json") do |tone_json|
  tone = tone_analyzer.tone(
    tone_input: JSON.parse(tone_json.read)["text"],
    content_type: "text/plain"
  ).result
  p tone
end

p "\ntone example 3:\n"
File.open(Dir.getwd + "/resources/tone-example.json") do |tone_json|
  tone = tone_analyzer.tone(
    tone_input: JSON.parse(tone_json.read)["text"],
    content_type: "text/plain",
    sentences: true
  ).result
  p tone
end

p "\ntone example 4:\n"
File.open(Dir.getwd + "/resources/tone-example.json") do |tone_json|
  tone = tone_analyzer.tone(
    tone_input: JSON.parse(tone_json.read),
    content_type: "application/json"
  ).result
  p tone
end

p "\ntone example 5:\n"
File.open(Dir.getwd + "/resources/tone-example-html.json") do |tone_html|
  tone = tone_analyzer.tone(
    tone_input: JSON.parse(tone_html.read)["text"],
    content_type: "text/html"
  ).result
  p tone
end
