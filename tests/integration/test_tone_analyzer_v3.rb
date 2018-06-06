require_relative("./../../core/watson-ruby/tone_analyzer_v3.rb")
require("json")
require("minitest/autorun")

class ToneAnalyzerV3Test < Minitest::Test
  def test_tone
    tone_text = File.read(Dir.getwd + "/resources/personality.txt")
    service = ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: ENV["TONE_ANALYZER_USERNAME"],
      password: ENV["TONE_ANALYZER_PASSWORD"]
    )
    assert(service.tone(tone_input: tone_text, content_type: "text/plain").status == 200)
  end

  def test_tone_with_args
    tone_text = File.read(Dir.getwd + "/resources/personality.txt")
    service = ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: ENV["TONE_ANALYZER_USERNAME"],
      password: ENV["TONE_ANALYZER_PASSWORD"]
    )
    assert(service.tone(tone_input: tone_text, content_type: "text/plain", sentences: false).status == 200)
  end

  def test_tone_chat
    service = ToneAnalyzerV3.new(
      version: "2017-09-21",
      username: ENV["TONE_ANALYZER_USERNAME"],
      password: ENV["TONE_ANALYZER_PASSWORD"]
    )
    utterances = [
      {
        "text" => "I am very happy",
        "user" => "glenn"
      }
    ]
    assert(service.tone_chat(utterances: utterances).status == 200)
  end
end
