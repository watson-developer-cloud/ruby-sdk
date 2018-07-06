require("ibm_watson/text_to_speech_v1")

# If using IAM
text_to_speech = IBMWatson::TextToSpeechV1.new(
  iam_api_key: "IAM API KEY"
)

# If you have username & password in your credentials use:
# text_to_speech = IBMWatson::TextToSpeechV1.new(
#   username: "YOUR SERVICE USERNAME",
#   password: "YOUR SERVICE PASSWORD"
# )

p text_to_speech.list_voices.body

File.new("output.wav", "w+") do |audio_file|
  response = text_to_speech.synthesize(
    text: "Hello world!",
    accept: "audio/wav",
    voice: "en-US_AllisonVoice"
  ).body
  audio_file << response
end

# p text_to_speech.get_pronunciation(text: "Watson", format: "spr").body

# p text_to_speech.list_voice_models.body

# p text_to_speech.create_voice_model(name: "test-customization").body

# p text_to_speech.update_voice_model(customization_id: "YOUR CUSTOMIZATION ID", name: "new name").body

# p text_to_speech.get_voice_model(customization_id: "YOUR CUSTOMIZATION ID").body

# p text_to_speech.list_words(customization_id: "YOUR CUSTOMIZATION ID").body

# p text_to_speech.add_words( # rubocop:disable Style/AsciiComments
#   customization_id: "YOUR CUSTOMIZATION ID",
#   words: [
#     {
#       "word" => "resume",
#       "translation" => "rɛzʊmeɪ"
#     }
#   ]
# ).body

# p text_to_speech.add_word(
#   customization_id: "YOUR CUSTOMIZATION ID",
#   word: "resume",
#   translation: "rɛzʊmeɪ"
# ).body # rubocop:enable Style/AsciiComments

# p text_to_speech.get_word(customization_id: "YOUR CUSTOMIZATION ID", word: "resume").body

# p text_to_speech.delete_word(customization_id: "YOUR CUSTOMIZATION ID", word: "resume")

# p text_to_speech.delete_voice_model(customization_id: "YOUR CUSTOMIZATION ID")
